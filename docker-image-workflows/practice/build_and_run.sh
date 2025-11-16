#!/bin/bash
# Build and Run Docker Image Script

echo "=== Building Docker Image ==="

# Build the image
echo "Building image: flask-app:latest"
docker build -t flask-app:latest .

echo ""
echo "=== Running Container ==="

# Run the container
echo "Running container on port 8080..."
docker run -p 8080:8080 flask-app

echo ""
echo "Access the application at: http://localhost:8080"
