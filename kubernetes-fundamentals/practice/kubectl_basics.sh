#!/bin/bash
# Kubernetes kubectl Basic Commands

echo "=== Kubernetes kubectl Basic Commands ==="

# Check cluster connection
echo "1. Checking cluster connection:"
echo "   kubectl cluster-info"
echo ""

# Get cluster nodes
echo "2. Listing cluster nodes:"
echo "   kubectl get nodes"
echo ""

# Get all resources
echo "3. Getting all resources in default namespace:"
echo "   kubectl get all"
echo ""

# Get pods
echo "4. Listing pods:"
echo "   kubectl get pods"
echo "   kubectl get pods -A  # All namespaces"
echo ""

# Describe a resource
echo "5. Describing a resource:"
echo "   kubectl describe pod <pod-name>"
echo "   kubectl describe node <node-name>"
echo ""

# Get services
echo "6. Listing services:"
echo "   kubectl get services"
echo ""

# Get deployments
echo "7. Listing deployments:"
echo "   kubectl get deployments"
echo ""

# Apply a manifest
echo "8. Applying a manifest file:"
echo "   kubectl apply -f deployment.yaml"
echo ""

# Delete a resource
echo "9. Deleting a resource:"
echo "   kubectl delete pod <pod-name>"
echo "   kubectl delete -f deployment.yaml"
echo ""

# Get logs
echo "10. Getting pod logs:"
echo "    kubectl logs <pod-name>"
echo "    kubectl logs -f <pod-name>  # Follow logs"
echo ""

# Execute command in pod
echo "11. Executing command in pod:"
echo "    kubectl exec -it <pod-name> -- /bin/bash"
echo ""

# Port forwarding
echo "12. Port forwarding:"
echo "    kubectl port-forward <pod-name> 8080:80"
echo ""

echo "kubectl basics demonstration complete!"
