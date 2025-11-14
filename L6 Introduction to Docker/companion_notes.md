# Docker and Containerization - Class Revision Notes

---

## Introduction to Docker and Containers

### What is Docker?

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications.

---

### Running Applications in Containers

Containers allow you to package an application with all parts it needs, such as libraries and other dependencies, and ship it all out as one package. This methodology ensures that the application runs reliably regardless of the environment it is running on.

---

## Basic Docker Commands

### Running a Container

- **docker run**: This command is used to start a new container.  
  Example:

```bash
docker run -it ubuntu bash
```

````

This starts a new Ubuntu container and gives you terminal access.

---

### Entering an Existing Container

- **docker exec**: Lets you run commands in a running container.
  Example:

```bash
docker exec -it <container_id> bash
```

This opens a terminal for a running container.

---

### Inspecting Docker Containers

- **docker ps**: Lists the running containers.
- **docker container inspect <container_id>**: Retrieves detailed information about the container, including its IP address.

---

## Working with Docker Images

### Creating and Managing Images

- Start with an existing image, make changes inside the container, then create a new image capturing these changes using `docker commit`.
- **docker images**: Lists available Docker images.
- **docker commit -m "" <container_id> <new_image_name>**: Creates a new image from a container.

---

### Pushing Images to Docker Hub

- **docker push <image_name>**: Uploads your image to Docker Hub.
- Ensure the image name starts with your Docker Hub username to push successfully.

---

## Networking and Container Communication

- Finding the IP address of a container is crucial when interacting with different containers.
- Use:

```bash
docker container inspect <container_id>
```

- Once the IP address is known, you can use commands like `curl` to communicate with the container.

---

## Dockerfile and Image Layers

- Images in Docker are typically created using a **Dockerfile**, which allows defining a multi-step build process.
- Each step contributes a new **layer** to the image.
- Understanding layers is key to efficient Docker image caching.

---

## Practical Usage Analogies

### Detached vs. Attached Modes

- **docker run -d**: Runs the container in detached mode (background).

### Importance of Layered Filesystems

- Each Docker image consists of layers. When you make modifications and commit them to a new image, you're essentially saving a new layer encapsulating those changes.

---

## Additional Insights

- The transition from virtual machines to Docker containers highlights efficiency. Docker does not carry the overhead of a full OS like VMs, as it utilizes the host OS.
- Multi-architecture environments (ARM vs. AMD) can encounter compatibility challenges, emphasizing the need for consistent architecture during image creation and deployment.

---

## Conclusion

Docker and its functionalities provide a powerful way to develop, ship, and run applications. Whether managing containers, running debugging sessions, or deploying in production environments, Docker offers flexibility and efficiency for modern software development needs.
````
