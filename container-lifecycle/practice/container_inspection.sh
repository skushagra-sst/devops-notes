#!/bin/bash
# Container Inspection Script

echo "=== Container Inspection ==="

# Start a container
echo "1. Starting nginx container:"
docker run -d --name test-nginx nginx
echo ""

# Show container processes on host
echo "2. Container processes on host:"
ps aux | grep nginx | grep -v grep
echo ""

# Inspect container
echo "3. Inspecting container:"
docker inspect test-nginx | grep -A 5 "State"
echo ""

# Show container logs
echo "4. Container logs:"
docker logs test-nginx | head -5
echo ""

# Show container stats
echo "5. Container stats (press Ctrl+C to exit):"
echo "   Run: docker stats test-nginx"
echo ""

# Stop and remove container
echo "6. Stopping and removing container:"
docker stop test-nginx
docker rm test-nginx
echo ""

echo "Container inspection demonstration complete!"
