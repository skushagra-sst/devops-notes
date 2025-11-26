# Kubernetes Introduction

## What is Kubernetes?

Kubernetes (K8s) is an open-source container orchestration platform.

Think of it as the "operating system for your data center," responsible for:
- Deploying containers
- Scaling them
- Healing them if something fails
- Networking them together
- Managing storage
- Rolling out updates gradually

It gives you infrastructure automation with self-healing and declarative state management.

## Kubernetes Architecture at a Glance

Kubernetes follows a master–worker architecture:
- **Control Plane (Master)** → Think of this as the "brain"
- **Data Plane (Worker Nodes)** → The "muscles" running your apps

### High-Level Layout

```
+------------------------+
|    Control Plane       |
+------------------------+
|   API Server           |
|   etcd                 |
|   Scheduler            |
|   Controller Manager   |
|   Cloud Controller Mgr |
+------------------------+
         |
--------------------------------
         |         |         |
+----------------+ +----------------+ +----------------+
| Worker Node    | | Worker Node    | | Worker Node    |
+----------------+ +----------------+ +----------------+
| Kubelet        | | Kubelet        | | Kubelet        |
| Kube-Proxy     | | Kube-Proxy     | | Kube-Proxy     |
| Container Runtm| | Container Runtm| | Container Runtm|
+----------------+ +----------------+ +----------------+
| Actual Pods    | | Actual Pods    | | Actual Pods    |
+----------------+ +----------------+ +----------------+
```

## Control Plane Components (The Brain of Kubernetes)

### kube-apiserver (The Front Door of Kubernetes)

This is the heart of the system.

**Key Functions:**
- Every `kubectl` CLI call goes only through this API server
- It validates requests
- Stores data in etcd
- Exposes a REST API

**Think of it like a receptionist who:**
- Checks if you're allowed (authn/authz)
- Validates your request
- Hands the request to the appropriate internal subsystem

**Characteristics:**
- It's stateless — you can run multiple replicas behind a load balancer
- All cluster communication flows through the API server
- Acts as the single source of truth for cluster state

### etcd (The Source of Truth)

etcd is a distributed key-value store.

**It stores:**
- Configurations
- Desired state
- Cluster metadata
- Secrets (encrypted at rest)
- Pod definitions
- Node status

**Critical Importance:**
- Kubernetes relies entirely on etcd
- If etcd is corrupt or lost — your cluster is essentially gone
- That's why large enterprises take etcd backups very seriously
- Typically runs in a highly available configuration (3 or 5 nodes)

### kube-scheduler (Decides where pods run)

The scheduler watches for pending pods and decides which node they should go to.

**It evaluates:**
- Resource availability (CPU, memory)
- Taints & tolerations
- Node affinity/anti-affinity
- Pod topology constraints
- Pod priority
- Node health
- Existing workloads

**Function:**
- It chooses the best possible node for each pod
- Ensures optimal resource utilization across the cluster
- Considers constraints and requirements

### kube-controller-manager

This is a collection of "control loops" that run continuously.

**Core Concept:**
Think of Kubernetes as constantly asking: "Is the actual state equal to the desired state?" If not, controllers take action.

**Important controllers:**
- **Node controller** → Detects when nodes die
- **Deployment controller** → Ensures correct ReplicaSets
- **ReplicaSet controller** → Manages pod counts
- **Job controller** → Handles batch jobs
- **ServiceAccount controller**
- **Volume controller**

**How controllers work:**
```
loop:
  read desired state from etcd
  read actual state from cluster
  if mismatch: fix it
```

### cloud-controller-manager (Only in cloud environments)

This component integrates Kubernetes with cloud providers like AWS, Azure, GCP.

**It manages:**
- Cloud-specific controllers:
  - **Node controller** → Detects cloud VM issues
  - **Route controller** → Configures cloud routing
  - **Service controller** → Creates ELBs
  - **PersistentVolume controller** → Creates storage disks dynamically

**Why it's needed:**
Without this, Kubernetes wouldn't be able to request:
- Load balancers
- Cloud disks
- Cloud networking resources

## Data Plane Components (The Muscle of Kubernetes)

Worker nodes are where your containers actually run.

### kubelet (Node Agent)

Every node runs a kubelet.

**Responsibilities:**
- Talks to the API server
- Ensures the containers actually run
- Monitors pod health
- Restarts containers if needed
- Mounts volumes
- Pulls images

**Example:**
If you describe a pod with `replicas: 3`, the kubelet on each node helps ensure that at least 3 pods always exist.

**Key Functions:**
- Registers the node with the API server
- Reports node and pod status
- Executes pod lifecycle management
- Manages container runtime

### kube-proxy (Cluster Networking)

kube-proxy programs the node's network rules so services work.

**Modes:**
- **iptables** (default)
- **ipvs** (more efficient for large clusters)

**Responsibilities:**
- Load balance traffic across pod endpoints
- Maintain Service → Pod mappings
- Allow east–west traffic inside the cluster

**Reliability:**
Even if 50 pods come and go behind a Service, kube-proxy keeps forwarding working reliably.

### Container Runtime (Docker, containerd, CRI-O)

Kubernetes doesn't run containers itself — it delegates to a runtime using CRI (Container Runtime Interface).

**Supported runtimes:**
- **containerd** (most common)
- **CRI-O** (popular in OpenShift)
- **Docker** (deprecated as runtime, but Docker images still OK)

**This runtime:**
- Pulls images
- Starts containers
- Manages namespaces/Cgroups
- Handles networking via CNI

## Additional Cluster Services

### CNI Plugin (Networking layer)

Handles pod networking:
- Assign IP per pod
- Create virtual interfaces
- Handle routes

**Popular CNIs:**
- **Calico** (policy-based networking)
- **Weave** (simple overlay network)
- **Cilium** (eBPF-based networking)
- **Flannel** (simple overlay)
- **AWS VPC CNI** (EKS)

### CSI Plugin (Storage layer)

Handles persistent volumes:
- EBS / Azure Disk / GCP PD
- NFS
- Ceph
- Local disks

**Function:**
Helps pods request storage dynamically.

## Putting Everything Together (Flow Example)

Let's say you run:
```bash
kubectl apply -f nginx-deploy.yaml
```

**Here's the flow:**

1. **kubectl → API Server**
   - Client sends request to API server

2. **API server writes desired state to etcd**
   - Desired state: 3 replicas of nginx

3. **Scheduler notices:**
   - "There is a pod with no node"

4. **Scheduler selects nodeA**
   - Based on resource availability and constraints

5. **kubelet on nodeA:**
   - Pull image
   - Create container
   - Setup networking (via CNI)

6. **kube-proxy updates service maps**
   - Enables service discovery and load balancing

7. **Controller manager watches:**
   - Ensures correct number of replicas
   - Maintains desired state

**Result:** You get a healthy deployment with zero manual effort.

## Visual: Complete Architecture

```
+-------------------------------+
|      Control Plane            |
+-------------------------------+
|   kube-apiserver              |
|   etcd                        |
|   kube-scheduler              |
|   kube-controller-manager     |
|   cloud-controller-manager    |
+-------------------------------+
         |
    (REST API)
         |
-------------------------------------------------------
         |         |         |
+----------------+ +----------------+ +----------------+
| Worker Node 1  | | Worker Node 2  | | Worker Node 3  |
+----------------+ +----------------+ +----------------+
| kubelet        | | kubelet        | | kubelet        |
| kube-proxy     | | kube-proxy     | | kube-proxy     |
| Runtime        | | Runtime        | | Runtime        |
| Pods           | | Pods           | | Pods           |
+----------------+ +----------------+ +----------------+
```

## Key Concepts

### Declarative vs Imperative

**Kubernetes is declarative:**
- You describe what you want (desired state)
- Kubernetes figures out how to achieve it
- Kubernetes continuously reconciles actual state with desired state

### Self-Healing

Kubernetes automatically:
- Restarts failed containers
- Replaces unhealthy pods
- Reschedules pods from failed nodes
- Maintains desired replica counts

### Scalability

Kubernetes can:
- Scale applications horizontally (add more pods)
- Scale the cluster itself (add more nodes)
- Handle thousands of nodes and pods

### Portability

Kubernetes runs on:
- Public clouds (AWS, Azure, GCP)
- Private clouds
- On-premises datacenters
- Edge devices
- Hybrid environments

## Summary

**Key Takeaways:**

1. **Architecture:**
   - Control Plane: Brain of the cluster (API server, etcd, scheduler, controllers)
   - Data Plane: Worker nodes running actual workloads
   - Components work together to maintain desired state

2. **Core Components:**
   - **API Server:** Central communication hub
   - **etcd:** Distributed key-value store for cluster state
   - **Scheduler:** Assigns pods to nodes
   - **Controller Manager:** Maintains desired state
   - **Kubelet:** Node agent managing pods
   - **Kube-proxy:** Network proxy for services

3. **Key Features:**
   - Declarative configuration
   - Self-healing capabilities
   - Automatic scaling
   - Service discovery and load balancing
   - Rolling updates and rollbacks
   - Storage orchestration

4. **Benefits:**
   - Infrastructure automation
   - High availability
   - Resource efficiency
   - Portability across environments
   - Ecosystem of tools and extensions

Kubernetes provides a robust platform for deploying, managing, and scaling containerized applications in production environments. Understanding its architecture is fundamental to effective Kubernetes operations.
