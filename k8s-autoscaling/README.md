# Understanding HPA - Horizontal Pod Autoscaler

## Kubernetes Horizontal Pod Autoscaler (HPA) – Detailed Tutorial

This tutorial explains Horizontal Pod Autoscaling (HPA) in Kubernetes using CPU-based autoscaling, step by step, with hands-on commands, why each step is required, and what to observe.

## What is HPA?

**Horizontal Pod Autoscaler (HPA)** automatically increases or decreases the number of pod replicas in a deployment based on resource usage (CPU/memory) or custom metrics.

**In this tutorial:**
- Metric: CPU utilization
- Scaling type: Horizontal (pods)
- Trigger: CPU > 50%

## Architecture Overview

```
User Load
   ↓
Service
   ↓
Pods (Deployment)
   ↓
Metrics Server → HPA Controller
   ↓
Replica Scale Up / Down
```

**How it works:**
1. Metrics Server collects resource metrics from pods
2. HPA controller reads metrics from Metrics Server
3. HPA compares current usage with target
4. HPA adjusts replica count via Deployment
5. Deployment creates/deletes pods to match desired count

## Step 1: Deploy Metrics Server (Mandatory)

### Why Metrics Server?

HPA depends on live resource metrics (CPU/memory). Without Metrics Server:
- HPA shows 0% CPU
- Scaling does NOT happen

### Install Metrics Server

```bash
kubectl apply -f https://github.com/vilasvarghese/docker-k8s/blob/master/yaml/metricServer/metric-server.yaml
```

**Or using official manifest:**
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Verify Installation

```bash
kubectl get pods -n kube-system | grep metrics-server
kubectl top nodes
```

**If metrics are visible, Metrics Server is working.**

**Expected output:**
```
NAME           CPU(cores)   MEMORY(bytes)
node1          100m         500Mi
```

## Step 2: Create a Deployment

### Purpose

This deployment runs a CPU-intensive sample application used for HPA testing.

### deployment.yml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hpa-demo-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      run: hpa-demo-deployment
  template:
    metadata:
      labels:
        run: hpa-demo-deployment
    spec:
      containers:
      - name: hpa-demo-deployment
        image: k8s.gcr.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 200m
          limits:
            cpu: 500m
```

### Apply Deployment

```bash
kubectl apply -f deployment.yml
kubectl get deploy
```

### Why CPU Requests Are Important

**HPA calculates utilization as:**
```
CPU Usage / CPU Request
```

**If `requests.cpu` is missing → HPA will NOT work.**

**Example:**
- CPU Usage: 100m
- CPU Request: 200m
- Utilization: 100m / 200m = 50%

## Step 3: Create a Service

### Why a Service?

The Service exposes the pods internally and provides a stable endpoint for load generation.

### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hpa-demo-deployment
  labels:
    run: hpa-demo-deployment
spec:
  ports:
  - port: 80
  selector:
    run: hpa-demo-deployment
```

### Apply Service

```bash
kubectl apply -f service.yaml
kubectl get svc
```

## Step 4: Create the Horizontal Pod Autoscaler

### What HPA Does Here

- Monitors CPU usage
- Scales pods between 1 and 10
- Targets 50% CPU utilization

### hpa.yaml

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-demo-deployment
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa-demo-deployment
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```

### Apply HPA

```bash
kubectl apply -f hpa.yaml
watch -n 1 kubectl get hpa
```

### Expected Output (Initially)

```
TARGETS: 0%/50%
```

**CPU shows 0% until Metrics Server starts reporting data.**

## Step 5: Generate Load

### Purpose

Simulate user traffic to increase CPU utilization.

### Load Generator Command

```bash
kubectl run -i --tty load-generator --rm \
  --image=busybox --restart=Never -- \
  /bin/sh -c "while sleep 0.01; do wget -q -O- http://hpa-demo-deployment; done"
```

**Alternative (using Apache Bench):**
```bash
kubectl run -i --tty load-generator --rm \
  --image=busybox --restart=Never -- \
  /bin/sh -c "while true; do wget -q -O- http://hpa-demo-deployment; done"
```

### Observe Scaling

```bash
kubectl get hpa
kubectl get hpa -w
watch -n 1 kubectl get deployment hpa-demo-deployment
```

### What Happens Internally

1. CPU usage crosses 50%
2. Metrics Server reports usage
3. HPA controller increases replicas
4. New pods are created

**Timeline:**
- T+0: Load starts, CPU increases
- T+15s: HPA checks metrics
- T+30s: HPA scales up (if needed)
- T+60s: New pods become ready

## Step 6: Monitor Metrics and Events

### View Pod CPU Usage

```bash
kubectl top pods --all-namespaces
kubectl top pods
```

### Describe Deployment

```bash
kubectl describe deploy hpa-demo-deployment
```

**Look for:**
- Replica count changes
- Scaling events

### Describe HPA

```bash
kubectl describe hpa hpa-demo-deployment
```

**Output shows:**
- Current metrics
- Target metrics
- Scaling events
- Last scale time

### View Events

```bash
kubectl get events --sort-by='.lastTimestamp'
```

## Step 7: Decrease the Load

**Stop the load generator (Ctrl+C).**

### Observe Scale Down

```bash
kubectl get hpa
kubectl get deployment hpa-demo-deployment
kubectl get events
```

### Scale Down Behavior

- HPA waits before scaling down (cooldown period)
- Gradual reduction of replicas
- Default cooldown: 5 minutes

**Why cooldown?**
- Prevents rapid scale up/down cycles
- Allows metrics to stabilize
- Reduces unnecessary churn

## HPA v2 API (Advanced)

**HPA v2 supports multiple metrics:**

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-demo-deployment
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa-demo-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
```

## Common Issues & Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| CPU shows 0% | Metrics Server missing | Install metrics-server |
| No scaling | CPU request missing | Add `requests.cpu` |
| HPA not working | Wrong selector | Match labels |
| HPA shows `<unknown>` | Metrics not available | Check Metrics Server |
| Scaling too aggressive | No stabilization window | Add `behavior` section |
| Scaling too slow | Cooldown too long | Adjust `stabilizationWindowSeconds` |

## Key Takeaways

1. **Metrics Server is mandatory for HPA** - must be installed first
2. **CPU requests are required** - HPA calculates utilization based on requests
3. **HPA reacts to average pod CPU usage** - across all pods in deployment
4. **Scaling is automatic and gradual** - respects min/max replicas
5. **Cooldown periods prevent thrashing** - stabilization windows
6. **HPA v2 supports multiple metrics** - CPU, memory, custom metrics

## Interview-Ready Explanation

"HPA monitors pod-level metrics via Metrics Server and automatically adjusts replicas based on CPU utilization thresholds defined in the HPA resource. It scales horizontally by increasing or decreasing the number of pod replicas in a deployment, ensuring optimal resource utilization while maintaining performance."

## Next Steps (Advanced Topics)

### Memory-based HPA

```yaml
metrics:
- type: Resource
  resource:
    name: memory
    target:
      type: Utilization
      averageUtilization: 80
```

### Custom Metrics HPA

Requires:
- Prometheus Adapter
- Custom metrics API
- Metric exporters

### HPA with Prometheus Adapter

- Expose Prometheus metrics to Kubernetes
- Use custom metrics for scaling
- More flexible than resource metrics

### VPA vs HPA

**VPA (Vertical Pod Autoscaler):**
- Adjusts resource requests/limits
- Changes pod size, not count
- Requires pod restart

**HPA (Horizontal Pod Autoscaler):**
- Adjusts replica count
- Changes pod count, not size
- No pod restart needed

### HPA with KEDA

**KEDA (Kubernetes Event-Driven Autoscaling):**
- Event-driven autoscaling
- Supports many scalers (Kafka, RabbitMQ, etc.)
- More flexible than standard HPA

## Best Practices

1. **Set appropriate min/max replicas** - prevent over/under scaling
2. **Use resource requests** - required for HPA to work
3. **Set reasonable targets** - 50-70% CPU is common
4. **Configure stabilization windows** - prevent rapid scaling
5. **Monitor HPA behavior** - watch events and metrics
6. **Test scaling behavior** - verify in non-production first
7. **Use HPA v2 API** - more features and flexibility

## Summary

**Key Concepts:**

1. **HPA automatically scales pods** based on metrics
2. **Metrics Server provides resource metrics** - CPU, memory
3. **CPU requests are mandatory** - for utilization calculation
4. **Scaling respects min/max** - prevents extreme scaling
5. **Cooldown periods** - prevent rapid scale cycles
6. **HPA v2 supports multiple metrics** - more flexible
7. **Works with Deployments** - manages replica count

HPA is essential for:
- Cost optimization
- Performance management
- Automatic scaling
- Resource efficiency

Mastering HPA enables automatic resource management and cost-effective Kubernetes deployments.
