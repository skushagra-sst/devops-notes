# Deep Dive into Kubernetes Services - Networking Model

## Guide to the Kubernetes Networking Model

This guide provides a deep-dive summary for easier learning, interview preparation, and architecture understanding.

## 1. Kubernetes Basics

### 1.1 API Server

- Central control plane component
- Exposes REST API
- Backed by etcd (cluster state store)
- Everything in Kubernetes = API call to the API server

### 1.2 Controllers

Watch the API (desired state) → compare with actual state → reconcile.

**Example:**
- Scheduler assigns Pods to nodes
- Kubelet on each node configures container runtime & networking

### 1.3 Pods

- Smallest deployable unit
- One or more containers
- Share:
  - Network namespace (same IP, same localhost)
  - Volumes

### 1.4 Nodes

Worker machines (VMs or bare metal).

**Run:**
- kubelet
- kube-proxy
- runtime (containerd, CRI-O)

## 2. The Kubernetes Networking Model (Design Principles)

Kubernetes imposes 3 hard rules:

1. **All Pods can talk to all other Pods WITHOUT NAT**
2. **All Nodes can talk to all Pods WITHOUT NAT**
3. **A Pod's IP is the same inside and outside the Pod**

**Because of this, Kubernetes must solve:**
1. Container-to-Container
2. Pod-to-Pod
3. Pod-to-Service
4. Internet-to-Service

## 3. Container-to-Container Networking (Inside a Pod)

Linux provides network namespaces, giving each container an isolated network stack.

**Inside a Pod:**
- Containers share the same network namespace
- They share:
  - IP
  - Ports
  - loopback

**Containers communicate using localhost.**

**Example:**
```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    image: nginx
  - name: sidecar
    image: logger
    # Both containers can communicate via localhost
```

## 4. Pod-to-Pod Networking

Pods get their own network namespaces, so Kubernetes must interconnect them.

### How Pods are Connected Inside a Node

**Each Pod's namespace uses a veth pair:**
```
Pod eth0 ←→ vethXXX ←→ root namespace
```

**Inside the node:**
- All veth interfaces connect to a Linux bridge (like cbr0)

### Traffic (Same Node)

1. Pod sends traffic → its eth0
2. Goes to veth → bridge
3. Bridge uses ARP to find destination Pod → forwards to its veth peer

**Flow:**
```
Pod A (eth0) → vethA → bridge (cbr0) → vethB → Pod B (eth0)
```

### Traffic (Different Nodes)

**Key idea:**
Each node gets a Pod CIDR range, e.g.,
- Node1: 10.0.1.0/24
- Node2: 10.0.2.0/24

**Flow:**
1. Pod → veth → bridge
2. Bridge cannot ARP → routes to node's default interface (eth0)
3. Node sends packet over the network to the destination node
4. Destination node receives → routes to Pod via its veth → namespace

**Flow:**
```
Pod A (Node1) → eth0 (Node1) → Network → eth0 (Node2) → veth → Pod B (Node2)
```

### How Does the Network Know Which Node Owns Which Pod IP Range?

This is CNI-specific.

#### Example: AWS VPC CNI

- Assigns real VPC IPs to each Pod (via ENIs)
- No overlays
- Pods behave as first-class VPC citizens

#### Other CNIs:

- **Calico:** Uses BGP for routing
- **Flannel:** Uses VXLAN overlay
- **Weave:** Uses VXLAN or fast datapath
- **Cilium:** Uses eBPF for networking

## 5. Pod-to-Service Networking (ClusterIP)

**Problem:**
- Pods come & go → IPs change frequently

**Service fixes this by providing:**
- A stable virtual IP (ClusterIP)
- A load balancer inside the cluster

### How Service Traffic is Routed?

**Two implementations:**

#### A. iptables (Classic)

kube-proxy writes iptables rules:
1. Watch for packets to ServiceIP
2. Randomly pick a backend Pod
3. DNAT (Destination NAT) to selected Pod
4. Return traffic is SNAT'ed back to Service IP (via conntrack)

**Flow:**
```
Client Pod → Service IP → iptables DNAT → Backend Pod IP
```

#### B. IPVS (Kubernetes Modern Default)

- Uses kernel-level load balancing
- More scalable
- Creates a dummy interface and binds the Service IP
- Faster + better for large clusters

**Flow:**
```
Client Pod → Service IP → IPVS → Backend Pod IP
```

### DNS (CoreDNS)

Kubernetes automatically creates DNS records for every Service:
```
myservice.mynamespace.svc.cluster.local
```

**CoreDNS runs as a Pod + Service inside cluster.**

**Short form (same namespace):**
```
myservice
```

## 6. Internet-to-Service Networking

### A. Egress (Pod → Internet)

**Problem:**
Internet Gateway knows only Node IPs, not Pod IPs.

**Solution:**
iptables SNAT every Pod→Internet packet:
- Pod IP → Node IP
- Then AWS internet gateway NATs Node private IP → public IP

**Flow:**
```
Pod (10.0.1.5) → SNAT → Node IP (192.168.1.10) → Internet Gateway → Public IP → Internet
```

### B. Ingress (Internet → Pods)

**Two methods:**

#### 1. Service Type = LoadBalancer (Layer 4)

Cloud provider creates:
- AWS ELB
- GCP LB
- Azure LB

**LB forwards traffic → NodePort → Pods**

**Good for:** Simple TCP/UDP

**Flow:**
```
Internet → Cloud LB → NodePort → Service → Pods
```

#### 2. Kubernetes Ingress Controller (Layer 7)

**Examples:**
- NGINX
- AWS ALB Ingress
- Traefik
- Istio Gateway

**Provides:**
- Host-based routing
- Path-based routing
- SSL termination

**Ingress → points to Services → Pods**

**Flow:**
```
Internet → Ingress Controller → Service → Pods
```

## In Short – Kubernetes Networking Explained

| Layer | What's happening? |
|-------|-------------------|
| **Container-to-Container** | Share same network namespace → localhost |
| **Pod-to-Pod (same node)** | veth pair → bridge → veth |
| **Pod-to-Pod (cross node)** | Routed through network based on Pod CIDR |
| **Pod-to-Service** | iptables/IPVS DNAT |
| **DNS** | CoreDNS resolves service names |
| **Egress** | SNAT Pod → Node → Internet |
| **Ingress** | LoadBalancer or Ingress Controller |

## Network Components Deep Dive

### CNI (Container Network Interface)

**Purpose:**
- Standard interface for network plugins
- Allocates IPs to pods
- Configures networking

**Popular CNIs:**
- **Calico:** Policy-based networking, BGP
- **Flannel:** Simple overlay network
- **Weave:** Encrypted mesh network
- **Cilium:** eBPF-based networking and security
- **AWS VPC CNI:** Native AWS networking

### kube-proxy

**Responsibilities:**
- Maintains network rules on each node
- Enables Service abstraction
- Load balances traffic to backend pods

**Modes:**
- **iptables:** Traditional, widely used
- **IPVS:** More efficient for large clusters
- **userspace:** Legacy, not recommended

### CoreDNS

**Purpose:**
- DNS server for Kubernetes
- Resolves service names to ClusterIPs
- Provides cluster-internal DNS

**Configuration:**
- Runs as Deployment in kube-system
- ConfigMap: `coredns`
- Service: `kube-dns`

## Service Discovery

### DNS-Based Discovery

**Format:**
```
<service-name>.<namespace>.svc.cluster.local
```

**Example:**
```
backend.default.svc.cluster.local → 10.96.0.1
```

### Environment Variables

Kubernetes injects environment variables for services:
```
BACKEND_SVC_SERVICE_HOST=10.96.0.1
BACKEND_SVC_SERVICE_PORT=80
```

**Note:** DNS is preferred over environment variables.

## Network Policies

**Purpose:**
- Control traffic between pods
- Implement network segmentation
- Security isolation

**Example:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

## Troubleshooting Networking

### Common Commands

```bash
# Check pod IPs
kubectl get pods -o wide

# Check services
kubectl get svc

# Check endpoints
kubectl get endpoints

# Check CoreDNS
kubectl get pods -n kube-system | grep coredns

# Test DNS resolution
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup backend-svc

# Check iptables rules
iptables -t nat -L -n

# Check kube-proxy
kubectl get pods -n kube-system | grep kube-proxy
```

### Common Issues

1. **Pods can't communicate:**
   - Check CNI plugin
   - Verify network policies
   - Check pod IP allocation

2. **Service not working:**
   - Verify service selector matches pod labels
   - Check endpoints exist
   - Verify kube-proxy is running

3. **DNS not resolving:**
   - Check CoreDNS pods
   - Verify service DNS name format
   - Check CoreDNS config

## Summary

**Key Takeaways:**

1. **Kubernetes networking follows strict rules** - no NAT between pods
2. **CNI plugins handle pod networking** - different implementations available
3. **Services provide stable networking** - abstract away pod IP changes
4. **kube-proxy enables service routing** - via iptables or IPVS
5. **CoreDNS provides service discovery** - DNS-based name resolution
6. **Ingress controllers handle Layer 7** - HTTP/HTTPS routing
7. **Network policies enable security** - control pod-to-pod communication

Understanding Kubernetes networking is essential for:
- Troubleshooting connectivity issues
- Designing microservices architecture
- Implementing security policies
- Optimizing network performance

Mastering these concepts enables effective Kubernetes cluster management and application deployment.
