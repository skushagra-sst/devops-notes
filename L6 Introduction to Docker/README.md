# Docker Class Summary

## Introduction

- Docker installation was part of the syllabus
- Docker allows creation of separate containers for different applications and dependencies

## Docker vs Virtual Machines

- Docker containers share the host OS kernel, while VMs have their own OS
- Docker interacts directly with the Linux kernel, not with specific distributions

## Docker Architecture

- Docker has a layered file system
- Default root folder: `/var/lib/docker`
- Storage driver: overlay2 (default)

## Docker Commands

- `docker run`: Creates and starts a container
- `docker ps`: Lists running containers
- `docker ps -a`: Lists all containers (including stopped ones)
- `docker stop`: Stops a running container
- `docker start`: Starts a stopped container
- `docker exec`: Executes a command in a running container
- `docker commit`: Creates a new image from a container's changes
- `docker push`: Pushes an image to a registry
- `docker pull`: Pulls an image from a registry
- `docker images`: Lists images
- `docker rmi`: Removes images
- `docker container prune`: Removes all stopped containers

## Docker Images

- Images are composed of multiple layers
- Layers are stored in the overlay2 folder
- Each layer depends on the previous layer
- Docker reuses layers when possible to save space

## Docker Hub

- Default remote registry for Docker images
- Requires account creation and login to push images

## Practical Examples

- Creating and modifying containers
- Committing changes to new images
- Pushing and pulling images from Docker Hub

## Docker Internals

- Explored the `/var/lib/docker` directory structure
- Discussed the role of different directories (images, containers, volumes, etc.)
- Explained the layered structure of Docker images

## Best Practices

- Regularly clean up unused images and containers to save space
- Use meaningful names and tags for images

## Potential Interview Questions

- Explaining Docker's internal structure
- Troubleshooting slow performance due to Docker usage
- Understanding image layers and how Docker optimizes storage

## Next Steps

- Creating custom images using Dockerfiles
- Deep dive into container internals
- Learning about Docker volumes
