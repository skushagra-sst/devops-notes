# Understanding Kubernetes Services

## The Problem Services Solve

Pods in Kubernetes are ephemeral, meaning they:
- Get new IPs on restart
- Can be recreated by ReplicaSets
- Can scale up/down dynamically

**You can't reliably communicate with pods directly.**

This is why Services exist — they provide a stable virtual IP (cluster-wide) and load balancing across pod replicas.

## What is a Kubernetes Service?

A Service is an abstraction that provides:
- A stable virtual IP (ClusterIP)
- A stable DNS name
- Load-balancing across backend pods
- Traffic routing through kube-proxy (iptables/ipvs)
- Access from inside or outside the cluster

## How a Service Works Internally

1. **You create a Service with a pod selector:**
   ```yaml
   selector:
     app: myapp
   ```

2. **Kube-proxy creates load-balancing rules using:**
   - iptables (older, common)
   - IPVS (newer, faster)

3. **Service gets a stable ClusterIP.**

4. **Any Pod contacting that ClusterIP goes through kube-proxy, which forwards traffic to matching pods.**

## Types of Kubernetes Services

There are 3 main service types:

| Service Type | Purpose | Accessible From |
|--------------|---------|-----------------|
| **ClusterIP** (default) | Internal communication | Inside the cluster |
| **NodePort** | Expose service on each node's IP | External (nodeIP:nodePort) |
| **LoadBalancer** | Expose service via cloud LB (AWS/ALB/ELB, GCP, Azure) | Internet or VPC |

## ClusterIP Service (Default)

This is the most common service type, used for internal service-to-service communication.

### Use Cases

- Microservices calling each other
- Internal databases
- Backends not exposed to internet
- Communication between frontend → backend

**Example:**
- frontend → backend
- backend → database

### ClusterIP YAML Example

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
spec:
  type: ClusterIP
  selector:
    app: backend
  ports:
  - port: 80        # Service port
    targetPort: 8080  # Pod containerPort
```

### Breakdown

- **port:** Port exposed by the service
- **targetPort:** Pod's container port
- **ClusterIP:** Assigned automatically

### How to Access

**Inside cluster:**
```bash
curl http://backend-svc
```

**Or using namespace:**
```bash
curl http://backend-svc.default.svc.cluster.local
```

## NodePort Service

This exposes a Service on every node's IP at a static port (NodePort).

**The port range for NodePort is: 30000–32767**

### Traffic Flow

```
External Client → NodeIP:NodePort → Service → Pods
```

### Use Cases

- Non-cloud environments (bare-metal)
- Local clusters (kubeadm, kind, minikube)
- Debugging external access

### NodePort YAML Example

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-nodeport
spec:
  type: NodePort
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 32080  # Optional; can be auto-assigned
```

### Access Externally

```bash
http://<NodeIP>:32080
```

You can hit any worker node IP — Kubernetes forwards it to the right pods.

### NodePort Limitations

- Exposes service on all nodes → not ideal for security
- Fixed high port range
- No smart routing (no CDN, health checks)
- Not production-grade for public internet

## LoadBalancer Service (Cloud Only)

Used to expose service publicly with a cloud load balancer.

### Supported In

- AWS (ELB, NLB, ALB)
- GCP
- Azure
- DigitalOcean

### Traffic Flow

```
Internet → Cloud Load Balancer → NodePort → Service → Pods
```

**Yes — internally LoadBalancer still uses NodePort.**

### LoadBalancer YAML Example

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-lb
spec:
  type: LoadBalancer
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8080
```

### After Creation

```bash
kubectl get svc backend-lb
```

**You will see:**
- `EXTERNAL-IP`: Public IP assigned by cloud provider

### Access

```bash
http://<EXTERNAL-IP>
```

## Additional Concepts

### Selectorless Services (Headless Services)

**Set:**
```yaml
spec:
  clusterIP: None
```

**Used for:**
- StatefulSets
- Databases
- DNS-based discovery

**Example:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-headless
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
  - port: 3306
```

**DNS returns individual pod IPs instead of service IP.**

### Multi-Port Services

A single service can expose multiple ports:

```yaml
ports:
- name: http
  port: 80
  targetPort: 8080
- name: https
  port: 443
  targetPort: 8443
```

### Service DNS Resolution

Every service gets DNS:
```
<servicename>.<namespace>.svc.cluster.local
```

**Example:**
```
redis.master.svc.cluster.local
```

**Short form (same namespace):**
```
redis
```

### Service Without Selector

**Used when:**
- Manually managing endpoints
- ExternalName services

**Example:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: database.company.com
```

## How Services Work with Endpoints

**Endpoints** are automatically created/updated by Kubernetes.

**When a Pod:**
- Becomes Ready → added to Endpoints
- Becomes NotReady → removed from Endpoints
- Is deleted → removed from Endpoints

**View endpoints:**
```bash
kubectl get endpoints <service-name>
```

**Endpoints contain:**
- List of pod IPs
- Ports
- Updated automatically by Endpoints controller

## kube-proxy Modes

### iptables Mode (Default)

- Uses iptables rules for load balancing
- More efficient than userspace mode
- No connection tracking overhead
- Rules updated when pods change

### IPVS Mode

- Uses IPVS (IP Virtual Server)
- Better performance for large clusters
- Supports more load balancing algorithms
- Requires IPVS kernel modules

**Enable IPVS:**
```yaml
# kube-proxy ConfigMap
mode: "ipvs"
```

## Service Discovery

### DNS-Based Discovery

**CoreDNS** (or kube-dns) provides DNS for services.

**Resolution:**
- `<service>.<namespace>.svc.cluster.local` → ClusterIP
- Short form: `<service>` (same namespace)

### Environment Variables

Kubernetes injects environment variables for services:
```
BACKEND_SVC_SERVICE_HOST=10.96.0.1
BACKEND_SVC_SERVICE_PORT=80
```

**Note:** DNS is preferred over environment variables.

## Which Service Type to Use?

| Need | Service Type |
|------|--------------|
| Internal-only microservices | ClusterIP |
| Expose to local network without cloud LB | NodePort |
| Production external access | LoadBalancer |
| StatefulSets / DBs | Headless (ClusterIP: None) |
| Access external DB | ExternalName |

## Service Best Practices

1. **Use ClusterIP for internal services** — most common use case
2. **Use LoadBalancer for production external access** — cloud environments
3. **Use NodePort sparingly** — mainly for development/testing
4. **Set proper selectors** — ensure service targets correct pods
5. **Use readiness probes** — only ready pods receive traffic
6. **Monitor endpoints** — ensure pods are being added/removed correctly
7. **Use headless services for StatefulSets** — direct pod access
8. **Configure session affinity if needed** — `sessionAffinity: ClientIP`

## Common Issues and Solutions

### Service Not Routing Traffic

**Check:**
- Service selector matches pod labels
- Pods are Ready (readiness probe passing)
- Endpoints exist: `kubectl get endpoints`
- kube-proxy is running

### External Access Not Working

**For NodePort:**
- Check firewall rules
- Verify nodePort range (30000-32767)
- Test with node IP

**For LoadBalancer:**
- Check cloud provider integration
- Verify cloud controller manager running
- Check cloud console for LB creation

### DNS Resolution Failing

**Check:**
- CoreDNS pods running
- Service DNS name format correct
- Namespace specified if different

## Service and Pod Lifecycle

**When Pod starts:**
1. Pod gets IP
2. Pod becomes Ready
3. Endpoints controller adds pod IP to Service endpoints
4. kube-proxy updates iptables/IPVS rules
5. Traffic can now reach pod

**When Pod stops:**
1. Pod termination begins
2. Readiness probe fails
3. Pod removed from Endpoints
4. kube-proxy removes rules
5. Traffic stops going to pod

## Summary

**Key Takeaways:**

1. **Services provide stable networking** for ephemeral pods
2. **Three main types:** ClusterIP, NodePort, LoadBalancer
3. **kube-proxy handles routing** via iptables or IPVS
4. **DNS-based service discovery** is the standard
5. **Endpoints automatically managed** by Kubernetes
6. **Choose service type** based on access requirements
7. **Services enable microservices communication** reliably

Services are fundamental to Kubernetes networking, enabling reliable communication between components in a dynamic, ever-changing environment.
