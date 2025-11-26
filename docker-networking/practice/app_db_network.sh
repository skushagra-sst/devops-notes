#!/bin/bash
# App + Database Network Example

echo "=== App + Database Network Setup ==="

# Create backend network
echo "1. Creating backend network..."
docker network create backend
echo ""

# Run MySQL database
echo "2. Starting MySQL database..."
docker run -d \
  --name db \
  --network backend \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=myapp \
  mysql:8.0
echo ""

# Wait for database to be ready
echo "3. Waiting for database to be ready..."
sleep 10
echo ""

# Run application container
echo "4. Starting application container..."
docker run -d \
  --name app \
  --network backend \
  -e DB_HOST=db \
  -e DB_NAME=myapp \
  -e DB_USER=root \
  -e DB_PASSWORD=secret \
  -p 8080:80 \
  nginx
echo ""

# Show network configuration
echo "5. Network configuration:"
docker network inspect backend | grep -A 10 "Containers"
echo ""

# Test connectivity
echo "6. Testing connectivity from app to db:"
docker exec app ping -c 2 db
echo ""

echo "Setup complete!"
echo "Application can connect to database using hostname 'db'"
echo "Access application at: http://localhost:8080"
