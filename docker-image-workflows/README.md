# Docker Image

## Part 1: Introduction — What Is a Docker Image?

A Docker image is more than a blueprint for a container. It includes the actual state executed, not just the blueprint.

**Key Characteristics:**
- It's a read-only, layered filesystem built using a Dockerfile
- When you run an image with `docker run`, Docker creates a container — a running instance with a writable layer on top of the image
- Images are immutable — once built, they don't change

## Part 2: Dockerfile Fundamentals

A Dockerfile is a recipe that defines how your image is built.

### Simple Dockerfile Example

```dockerfile
# Simple Dockerfile Example
FROM python:3.12-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

Let's break down each instruction.

### 1. FROM — Base Image

**Syntax:**
```dockerfile
FROM <image>[:<tag>]
```

**Purpose:**
- Specifies the base image (starting point)
- Every image must start with a `FROM` (except for scratch images)
- `ARG` is the only command that can be before `FROM`, but that is rarely used

**Examples:**
```dockerfile
FROM ubuntu:22.04
FROM python:3.12-slim
FROM node:20-alpine
```

**Best Practices:**
- Use lightweight images (`-alpine`, `-slim`) to reduce image size
- Always pin versions (e.g., `python:3.12-slim`) for reproducibility
- Use `scratch` for building minimal images (for Go, Rust, etc.)

### 2. RUN — Execute Commands During Build

**Syntax:**
```dockerfile
RUN <command>
RUN ["executable", "param1", "param2"]
```

**Purpose:**
- Used to install software, set up environment, or configure files
- Creates a new image layer for each `RUN` command

**Example:**
```dockerfile
RUN apt-get update && apt-get install -y curl
RUN pip install flask
```

**Best Practices:**
- Combine related commands to reduce image layers:
  ```dockerfile
  RUN apt-get update && apt-get install -y curl python3-pip && \
      rm -rf /var/lib/apt/lists/*
  ```
- Always clean up caches and temporary files
- Use multi-stage builds for smaller final images

### 3. CMD — Default Command to Run in Container

**Syntax:**
```dockerfile
CMD ["executable", "param1", "param2"]  # exec form (recommended)
CMD command param1 param2                # shell form
```

**Purpose:**
- Defines the default command that runs when the container starts
- You can override it using `docker run <image> <your_command>`

**Example:**
```dockerfile
CMD ["python", "app.py"]
```

**Best Practices:**
- Always use JSON (exec) form — avoids spawning an extra shell
- Only one `CMD` per Dockerfile — the last one overrides others

### 4. ENTRYPOINT — Fixed Main Command

**Syntax:**
```dockerfile
ENTRYPOINT ["executable", "param1", "param2"]
```

**Purpose:**
- Used to define the main application that should always run
- `CMD` is often used to provide default arguments to `ENTRYPOINT`

**Example:**
```dockerfile
ENTRYPOINT ["python", "app.py"]
```

Now even if you run:
```bash
docker run myapp arg1
```

it executes:
```bash
python app.py arg1
```

**Best Practice:**
- Use `ENTRYPOINT` for your main app and `CMD` for its arguments

### 5. Combining ENTRYPOINT and CMD

You can use both together for flexibility.

**Example:**
```dockerfile
FROM ubuntu:22.04
ENTRYPOINT ["echo"]
CMD ["Hello, World!"]
```

**Behavior:**
- If you run: `docker run myimage`
  - Output → `Hello, World!`
- If you override CMD: `docker run myimage Goodbye`
  - Output → `Goodbye`

**Concept:**
- `ENTRYPOINT` = Fixed executable
- `CMD` = Default argument

### 6. ADD and COPY — Copying Files into the Image

Both copy files from host → image, but they differ slightly.

#### COPY

**Simplest and most common** — just copies files/directories.

```dockerfile
COPY requirements.txt /app/
COPY . /app
```

**Best Practice:** Use `COPY` whenever possible — it's predictable and explicit.

#### ADD

Adds files and supports:
- Remote URLs
- Automatic tar extraction

```dockerfile
ADD https://example.com/file.tar.gz /tmp/
ADD myapp.tar.gz /app/
```

**Best Practice:** Use only when you need those extra features. Don't use `ADD` for normal local file copies — it's less transparent.

### 7. ENV — Set Environment Variables

**Syntax:**
```dockerfile
ENV <key>=<value>
```

**Example:**
```dockerfile
ENV APP_ENV=production
ENV PORT=8080
```

**Purpose:**
- Used to configure runtime environment for your app

**Best Practices:**
- Use `ENV` for config that shouldn't change often
- Use `docker run -e KEY=value` for dynamic values

### 8. WORKDIR — Set Working Directory

**Syntax:**
```dockerfile
WORKDIR /app
```

**Purpose:**
- Sets the working directory for subsequent commands
- Creates the directory if it doesn't exist
- All `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` commands after this will execute in this directory

### 9. EXPOSE — Document Ports

**Syntax:**
```dockerfile
EXPOSE 8080
EXPOSE 80/tcp
```

**Purpose:**
- Documents which ports the container will listen on
- Does NOT actually publish the port — you still need `-p` flag in `docker run`
- Useful for documentation and Docker Compose

## Part 3: Building a Real-World Docker Image Example

Let's build a Flask web app image — production ready.

### Directory Structure

```
flask-app/
├── app.py
├── requirements.txt
└── Dockerfile
```

### app.py

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

### requirements.txt

```
flask==3.0.2
```

### Dockerfile

```dockerfile
# Stage 1: Base
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy dependency file first for caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the source code
COPY . .

# Set environment variables
ENV PORT=8080

# Expose port
EXPOSE 8080

# Use entrypoint and cmd
ENTRYPOINT ["python"]
CMD ["app.py"]
```

### Build and Run

```bash
docker build -t flask-app:latest .
docker run -p 8080:8080 flask-app
```

Access at → `http://localhost:8080`

**Key Points:**
- Copy `requirements.txt` first to leverage Docker layer caching
- Use `--no-cache-dir` to reduce image size
- Expose port 8080 to document the application port
- Use `ENTRYPOINT` and `CMD` together for flexibility

## Part 4: Docker Image Best Practices

| Category | Best Practice | Why |
|----------|---------------|-----|
| **Base Image** | Use minimal images (`-alpine`, `-slim`) | Reduces size and attack surface |
| **Layers** | Combine related `RUN`s | Fewer layers = smaller image |
| **Caching** | Copy dependency files early | Avoids reinstalling packages unnecessarily |
| **Cleanup** | Remove caches (`rm -rf /var/lib/apt/lists/*`) | Prevents bloat |
| **Security** | Use non-root user (`USER appuser`) | Prevents privilege escalation |
| **Scanning** | Use `docker scan` or Trivy | Detects vulnerabilities |
| **Secrets** | Don't hardcode passwords or tokens | Use environment variables or Docker secrets |
| **Versioning** | Pin base images and dependencies | Ensures reproducibility |
| **Multi-stage Builds** | Use multiple stages to reduce size | Only final stage goes to production |
| **Healthcheck** | Add `HEALTHCHECK` instruction | Detect and auto-restart unhealthy containers |

### Example — Secure Image Setup

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    useradd -m appuser

COPY . .
USER appuser

EXPOSE 8080

ENTRYPOINT ["python"]
CMD ["app.py"]
```

**Security Features:**
- Runs as non-root user
- Minimal base image
- Cached dependency installation
- No unnecessary packages

## Part 5: Bonus — Inspecting and Analyzing Your Image

### List Image Layers

```bash
docker history flask-app
```

Shows each layer, its size, and the command that created it.

### Inspect Metadata

```bash
docker inspect flask-app
```

Returns JSON with detailed information about the image:
- Layers
- Environment variables
- Exposed ports
- Entrypoint and CMD
- Creation date
- Architecture

### Scan for Vulnerabilities

**Using Docker Scan:**
```bash
docker scan flask-app
```

**Using Trivy:**
```bash
trivy image flask-app
```

Scans the image for known vulnerabilities in packages and dependencies.

### View Image Size

```bash
docker images flask-app
```

Shows the size of the image and its layers.

## Building Images with Custom Dockerfile Names

If your Dockerfile has a different name or location:

```bash
docker build -t <image-name> -f <dockerfile-path> .
```

**Example:**
```bash
docker build -t myapp:latest -f dockerfiles/Dockerfile.prod .
```

## Summary

**Key Takeaways:**
- Dockerfiles define how images are built
- Each instruction creates a new layer
- Layer caching speeds up builds
- Best practices reduce image size and improve security
- Images are read-only templates for containers
- Use `ENTRYPOINT` for fixed commands, `CMD` for defaults
- Always use specific versions for reproducibility
- Scan images for vulnerabilities before deployment

Mastering Dockerfile creation is essential for building efficient, secure, and maintainable containerized applications.
