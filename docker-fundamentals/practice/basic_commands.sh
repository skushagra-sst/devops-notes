#!/bin/bash
# Basic Docker Commands Practice Script

echo "=== Basic Docker Commands ==="

# Check Docker version
echo "1. Checking Docker version:"
docker --version
echo ""

# List running containers
echo "2. Listing running containers:"
docker ps
echo ""

# List all containers (including stopped)
echo "3. Listing all containers:"
docker ps -a
echo ""

# List images
echo "4. Listing Docker images:"
docker images
echo ""

# Pull an image
echo "5. Pulling nginx image:"
docker pull nginx
echo ""

# Run a container
echo "6. Running hello-world container:"
docker run hello-world
echo ""

# Run interactive container
echo "7. To run an interactive Ubuntu container, use:"
echo "   docker run -it ubuntu bash"
echo ""

echo "Basic commands demonstration complete!"
