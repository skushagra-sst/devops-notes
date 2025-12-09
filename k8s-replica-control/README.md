# Deep Dive into Kubernetes ReplicaSets

## Overview

A ReplicaSet (RS) is a Kubernetes controller responsible for ensuring a specified number of Pod replicas are always running.

**Core Function:**
A ReplicaSet continuously compares:
- **Desired state** (`spec.replicas`)
- vs
- **Current state** (number of pods matching label selector)

**If mismatch:**
- It creates Pods
- It deletes excess Pods
- It replaces failed Pods

**Components Involved:**
- kube-apiserver
- kube-controller-manager
- kube-scheduler
- kubelet
- etcd

## Basic ReplicaSet YAML

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

**Apply:**
```bash
kubectl apply -f nginx-rs.yaml
```

## Full Control Plane Flow

### Step 1: kubectl → API Server

kubectl sends the ReplicaSet definition as a REST request to:
```
kube-apiserver:443/apis/apps/v1/replicasets
```

**The API server:**
1. Authenticates (AuthN)
2. Authorizes (RBAC)
3. Admits (Validating/Mutating Webhooks)
4. Stores the ReplicaSet object in etcd

**etcd state after storing ReplicaSet:**
```
/registry/replicasets/default/nginx-rs
  - spec.replicas = 3
  - selector = app=web
  - pod template stored here
```

### Step 2: ReplicaSet Controller Starts Acting

Running inside `kube-controller-manager`, the replicaset controller watches the API server via a watch stream.

**It receives an event:**
- `ADDED ReplicaSet "nginx-rs"`

**The controller compares:**
- current pod count = 0
- desired pod count = 3

**So it decides to create 3 Pods.**

**It sends Pod objects to the API server:**
```
POST /api/v1/namespaces/default/pods
```

Each Pod uses the template stored inside the ReplicaSet.

### Step 3: etcd After Pod Creation

Three pod entries appear:
```
/registry/pods/default/web-abc12
/registry/pods/default/web-def34
/registry/pods/default/web-ghi56
```

**Within each Pod object:**
- `metadata.ownerReferences` points to the ReplicaSet
- `status.phase = Pending`
- `spec.nodeName = ""` (no node assigned yet)

### Step 4: Scheduler Now Gets Involved

The `kube-scheduler` continuously watches the API server for Pending pods with no node assigned.

**It receives:**
- `ADDED Pod web-abc12`
- `ADDED Pod web-def34`
- `ADDED Pod web-ghi56`

**For each pod:**
1. Scheduler runs its scheduling logic (fit + priority)
2. Selects a node (example: node1)
3. Writes binding back to API server:
   ```
   POST /api/v1/namespaces/default/pods/web-abc12/binding
   spec.nodeName = node1
   ```

**etcd after scheduling:**
Each pod gets updated:
- `spec.nodeName = node1` (or node2, node3 ...)
- `status.phase = Scheduled` (not Running yet)

### Step 5: Kubelet on Each Node Takes Over

Each worker node's kubelet watches:
```
/api/v1/pods?fieldSelector=spec.nodeName=<this node>
```

**When kubelet sees the Pod assigned to its node:**
1. It pulls the image
2. Creates container via container runtime (Docker, containerd, CRI-O)
3. Starts it
4. Updates the API server with pod status:
   - `status.phase = Running`

This updated status is stored in etcd.

## ReplicaSet Controller Continuous Reconciliation Loop

The ReplicaSet controller **ALWAYS** runs this loop:

```
Read from API server:
  List Pods matching selector app=web

Compare:
  desired: 3
  current: 3

Equal → do nothing.
```

**The controller continuously:**
- Watches for Pod changes
- Compares desired vs actual
- Takes corrective action when needed

## Failure Scenarios — How ReplicaSet Reacts

### Pod Crashes

**kubelet updates:**
- `status.phase = Failed`

**ReplicaSet sees:**
- desired = 3
- running = 2

**→ Creates a new Pod object**

### Node Dies

If node stays NotReady for ~5 minutes, node controller marks all pods as:
- `status.phase = Unknown`

**Then the ReplicaSet controller:**
- Deletes those pods
- Creates replacements

### You Manually Delete a Pod

If deletion is not with `--cascade=orphan`, the RS sees:
- 2 running
- desired 3

**→ Creates 1 new pod**

## If You Delete the ReplicaSet Itself

**You run:**
```bash
kubectl delete rs nginx-rs
```

**The API server:**
- Marks RS for deletion → stored in etcd

**The ReplicaSet controller receives:**
- `DELETED ReplicaSet nginx-rs`

**It deletes all owned pods.**

All pod entries are removed from etcd.

## Putting It All Together — ETCD Illustration

Below is a simplified view of how objects exist in etcd:

```
/registry
├── replicasets
│   └── default
│       └── nginx-rs
│           - spec.replicas = 3
│           - selector: app=web
│           - podTemplate
│
├── pods
│   └── default
│       ├── web-abc12
│       │   - ownerRef = nginx-rs
│       │   - spec.nodeName = node1
│       │   - status: Running
│       ├── web-def34
│       └── web-ghi56
│
└── nodes
    ├── node1
    ├── node2
    └── node3
```

## ReplicaSet Summary (Deep Insight)

| Component | Role |
|-----------|------|
| **kubectl** | Sends ReplicaSet YAML to API server |
| **API Server** | Validates and stores object in etcd |
| **etcd** | Stores desired state for RS and Pods; stores actual pod status |
| **ReplicaSet Controller** | Detects pod count mismatch and creates/deletes pods |
| **Scheduler** | Assigns pods to nodes |
| **Kubelet** | Creates, manages containers on node; reports status |
| **Container Runtime** | CRI-O/Docker/containerd actually runs containers |

**Key Insight:** ReplicaSets are purely controllers — they never run pods; they only ensure correct count.

## How ReplicaSet Selects Pods

ReplicaSet uses label selectors to identify which Pods it manages:

```yaml
selector:
  matchLabels:
    app: web
```

**Rules:**
- Pods must match ALL labels in `matchLabels`
- Pods can have additional labels
- If a Pod's labels change and no longer match, ReplicaSet stops managing it

## ReplicaSet vs ReplicationController

**ReplicationController (old):**
- Only supports equality-based selectors
- Being phased out

**ReplicaSet (modern):**
- Supports both equality-based and set-based selectors
- More flexible label matching
- Used by Deployments

## Scaling a ReplicaSet

**Scale up:**
```bash
kubectl scale rs nginx-rs --replicas=5
```

**What happens:**
1. ReplicaSet spec updated in etcd
2. Controller sees desired=5, current=3
3. Creates 2 new Pods

**Scale down:**
```bash
kubectl scale rs nginx-rs --replicas=1
```

**What happens:**
1. ReplicaSet spec updated in etcd
2. Controller sees desired=1, current=3
3. Deletes 2 Pods (oldest first, typically)

## ReplicaSet Status

**Check status:**
```bash
kubectl get rs nginx-rs
```

**Output shows:**
- `DESIRED`: Number of replicas specified
- `CURRENT`: Number of pods currently running
- `READY`: Number of pods that are ready (readiness probe passed)

## Best Practices

1. **Don't create ReplicaSets directly** — use Deployments instead
2. **Use meaningful labels** for selector matching
3. **Set resource requests/limits** in pod template
4. **Use readiness probes** to ensure pods are truly ready
5. **Monitor ReplicaSet status** to detect issues early

## Common Issues and Solutions

### Pods Not Being Created

**Check:**
- ReplicaSet selector matches pod labels
- Node resources available
- Image pull secrets configured
- Resource quotas not exceeded

### Pods Being Deleted Immediately

**Check:**
- Another controller managing same pods
- Pod labels changed
- ReplicaSet selector too broad

### Pods Stuck in Pending

**Check:**
- Node resources (CPU, memory)
- Node selectors and affinity
- Taints and tolerations
- Volume attachments

## Summary

**Key Takeaways:**

1. **ReplicaSet ensures desired replica count** — continuously reconciles actual vs desired
2. **Uses label selectors** to identify managed pods
3. **Works with scheduler and kubelet** to place and run pods
4. **Self-healing** — replaces failed or deleted pods automatically
5. **Stored in etcd** — desired state persisted, actual state reported
6. **Typically managed by Deployments** — rarely created directly

ReplicaSets provide the foundation for maintaining pod counts, which is essential for high availability and reliability in Kubernetes.
