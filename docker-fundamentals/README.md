# Docker Introduction

## What is Docker?

### Definition

Docker is an open-source platform designed to build, package, ship, and run applications in containers.

A container is a lightweight, standalone, and executable software package that includes everything needed to run an application:
- Code
- Runtime
- Libraries
- System tools
- Configuration

This ensures that an app runs the same way everywhere — on your laptop, a server, or in the cloud.

## Why Do We Need Docker?

### Before Docker (Traditional Deployment)

- You'd install your app + dependencies directly on the OS
- Different apps might require different library versions (conflicts)
- Deploying the same app on another machine often required manual setup again
- Environment inconsistencies between development, staging, and production

### With Docker

- Each app runs in its own container, isolated from others
- Containers include all dependencies, so the environment is consistent everywhere
- You can start, stop, copy, or remove containers easily
- "Works on my machine" becomes "works everywhere"

## Key Concepts and Components

| Concept | Description |
|---------|-------------|
| **Image** | A read-only blueprint that defines what a container is. Built from a Dockerfile. |
| **Container** | A running instance of an image. You can create, start, stop, or delete containers. |
| **Dockerfile** | A text file with instructions to build an image (e.g., which OS, dependencies, commands). |
| **Docker Engine** | The runtime that builds and runs containers. |
| **Docker Hub** | Public repository of images (like GitHub for code). |
| **Docker Compose** | Tool for defining and running multi-container applications (via docker-compose.yml). |

## Docker Architecture

### Client-Server Model

```
+----------------------------------------+
| Docker CLI (Client)                   |
+----------------------------------------+
         ↓ talks to
+----------------------------------------+
| Docker Daemon (Server)                 |
| - Builds, runs, and manages containers |
+----------------------------------------+
         ↓
+----------------------------------------+
| Container Runtime Layer               |
| - Images                               |
| - Containers                           |
+----------------------------------------+
         ↓
+----------------------------------------+
| Host Operating System                  |
+----------------------------------------+
```

**How it works:**
- `docker` command (CLI) talks to the Docker Daemon (background service)
- The daemon does the heavy lifting (build, pull, run images)
- The daemon communicates with the container runtime to manage containers

## Installing Docker

### Using Convenience Script (Recommended)

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### For Ubuntu/Debian

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
```

### Verify Installation

```bash
docker --version
docker run hello-world
```

**Note:** After installation, you may need to add your user to the docker group to run Docker without sudo:
```bash
sudo usermod -aG docker $USER
# Log out and log back in for changes to take effect
```

## Basic Docker Commands

| Task | Command | Description |
|------|---------|-------------|
| Check version | `docker --version` | Verify Docker installation |
| Run a container | `docker run hello-world` | Test setup with a simple container |
| List containers | `docker ps` | Show active (running) containers |
| List all (incl. stopped) | `docker ps -a` | Show all containers (running and stopped) |
| List images | `docker images` | Show installed images |
| Pull image | `docker pull nginx` | Download image from Docker Hub |
| Run interactive | `docker run -it ubuntu bash` | Open terminal inside Ubuntu container |
| Stop container | `docker stop <container_id>` | Gracefully stop a running container |
| Remove container | `docker rm <container_id>` | Delete a stopped container |
| Remove image | `docker rmi <image_id>` | Delete an image |

### Common Command Options

- `-it`: Interactive terminal (combines `-i` for interactive and `-t` for TTY)
- `-d`: Run in detached mode (background)
- `-p`: Port mapping (e.g., `-p 8080:80` maps host port 8080 to container port 80)
- `-v`: Volume mounting (e.g., `-v /host/path:/container/path`)
- `--name`: Give container a name (e.g., `--name my-container`)

## Docker Images Overview

### What is a Docker Image?

A Docker image is a read-only, layered template used to create Docker containers. Each image contains everything needed to run a piece of software — code, runtime, system libraries, environment variables, and configuration files.

### Layered File System (Union File System)

Docker images are made up of multiple layers, stacked on top of each other using a union file system (like OverlayFS, AUFS, or Btrfs).

Each layer represents a set of filesystem changes (add, modify, delete files).

**Example:**
```
FROM ubuntu:22.04          → Base layer
RUN apt-get install nginx → Adds a new layer
COPY . /var/www/html      → Adds another layer
CMD ["nginx", "-g", "daemon off;"] → Final metadata layer
```

Each `RUN`, `COPY`, or `ADD` command in a Dockerfile creates a new layer.

### Visual: Docker Image Layer Architecture

```
+------------------------------------+
| CMD / ENTRYPOINT (metadata layer)  |
+------------------------------------+
| COPY app files / configs           |
+------------------------------------+
| RUN apt-get install nginx          |
+------------------------------------+
| FROM ubuntu:22.04 (Base OS Layer)  |
+------------------------------------+
         ↑
    Read-only Layers
```

When you start a container, Docker adds a read-write layer on top of these read-only layers:

**Container View:**
```
+------------------------------------+
| Writable Container Layer (diffs)   | ← changes while running
+------------------------------------+
| Read-only Image Layers (base img)  |
+------------------------------------+
```

### How Union File System Works

UnionFS merges all these layers into a single unified view:
- If a file exists in multiple layers, Docker uses the topmost copy (copy-on-write mechanism)
- If a file is modified or deleted in a container:
  - It's first copied from the read-only layer into the writable layer
  - Modifications happen only in the writable layer

### Where Are Docker Images Stored?

Depends on the storage driver and operating system.

**On Linux (default: overlay2):**
Images and layers are stored under `/var/lib/docker/overlay2/`

**Structure:**
```
/var/lib/docker/
├── overlay2/
│   ├── <layer_id>/
│   │   ├── diff/  ← actual filesystem changes
│   │   ├── lower/ ← references to parent layers
│   │   └── work/  ← temp area used by OverlayFS
├── image/
│   └── overlay2/
│       ├── imagedb/
│       │   └── content/sha256/ ← image metadata
│       └── layerdb/ ← layer relationships
```

### Inspecting Layers

You can view layers and their digests using:

```bash
docker image inspect <image_name> --format='{{json .RootFS.Layers}}' | jq
```

Or list all layers:

```bash
docker history <image_name>
```

**Example output:**
```
IMAGE          CREATED BY                          SIZE
<missing>      /bin/sh -c #(nop) CMD ...           0B
<missing>      /bin/sh -c apt-get install nginx... 25MB
<missing>      /bin/sh -c apt-get update          1.2MB
<missing>      /bin/sh -c #(nop) FROM ubuntu:22.04
```

Each line = one layer.

### Layer Reuse and Caching

Docker uses content-addressable storage — layers are identified by SHA256 hashes.

**Benefits:**
- If two images use the same base layers, Docker does not duplicate them
- This makes builds faster and space-efficient
- Layers are cached, so rebuilding only rebuilds changed layers

## Summary

Docker revolutionizes application deployment by:

1. **Consistency:** Same environment everywhere (dev, staging, production)
2. **Isolation:** Each application runs in its own container
3. **Portability:** Run anywhere Docker is installed
4. **Efficiency:** Lightweight compared to virtual machines
5. **Scalability:** Easy to scale applications horizontally
6. **Version Control:** Images can be versioned and tagged

**Key Takeaways:**
- Docker uses a client-server architecture
- Images are read-only templates built from Dockerfiles
- Containers are running instances of images with a writable layer
- Images use layered filesystem for efficiency
- Docker Hub provides a registry for sharing images

Mastering Docker fundamentals is essential for modern DevOps practices and containerized application deployment.
