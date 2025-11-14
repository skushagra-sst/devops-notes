# Docker Class Summary

## Introduction to Docker

- Docker is a platform for creating and managing containers
- Containers are lightweight compared to virtual machines
- Docker's usage in production is decreasing, but it's still the best platform for learning containerization

## Key Concepts

1. **Containers**: Similar to virtual machines but more lightweight
2. **Images**: Templates used to create containers
3. **Docker Hub**: Remote repository for Docker images
4. **Docker Daemon**: Background process that manages Docker objects
5. **Docker Client**: Command-line interface to interact with Docker

## Basic Docker Commands

- `docker run`: Create and start a new container
- `docker images`: List available images
- `docker ps`: List running containers

## Container vs Virtual Machine

- Containers share the host OS kernel, making them lighter and faster to start
- Virtual machines have their own OS, making them heavier but more isolated

## Docker Architecture

- Docker client communicates with Docker daemon
- Docker daemon manages images, containers, and interacts with the host OS

## Practical Examples

- Created a "Hello World" container
- Explored an Ubuntu container interactively

## Key Takeaways

- Docker simplifies application deployment with the "if it fits, it ships" philosophy
- Containers are more efficient and faster to start compared to virtual machines
- Docker images can be stored locally or remotely (e.g., Docker Hub)
- Understanding the difference between Docker client and daemon is crucial
