#!/bin/bash
# Docker Network Commands Practice Script

echo "=== Docker Network Commands ==="

# List all networks
echo "1. Listing all Docker networks:"
docker network ls
echo ""

# Inspect default bridge network
echo "2. Inspecting default bridge network:"
docker network inspect bridge | head -20
echo ""

# Create a custom bridge network
echo "3. Creating custom bridge network:"
docker network create mynetwork
echo ""

# Create network with specific subnet
echo "4. Creating network with subnet:"
docker network create --subnet=172.20.0.0/16 mynet-subnet
echo ""

# Run containers on custom network
echo "5. Running containers on custom network:"
echo "   docker run -d --name web --network mynetwork nginx"
echo "   docker run -d --name app --network mynetwork alpine sleep 3600"
echo ""

# Connect container to network
echo "6. Connecting existing container to network:"
echo "   docker network connect mynetwork container_name"
echo ""

# Disconnect container from network
echo "7. Disconnecting container from network:"
echo "   docker network disconnect mynetwork container_name"
echo ""

# Inspect network to see connected containers
echo "8. Inspecting network to see connected containers:"
docker network inspect mynetwork | grep -A 5 "Containers"
echo ""

# Remove network (must disconnect containers first)
echo "9. To remove a network:"
echo "   docker network rm mynetwork"
echo ""

# Port mapping example
echo "10. Port mapping example:"
echo "    docker run -d -p 8080:80 --name nginx-web nginx"
echo "    Access at: http://localhost:8080"
echo ""

echo "Network commands demonstration complete!"
