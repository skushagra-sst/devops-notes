# Docker Image Creation and Dockerfile Commands

## Introduction to Docker Images

- Docker images are more than just blueprints; they contain actual installed components
- Images are created from Dockerfiles

## Basic Dockerfile Commands

### FROM

- Specifies the base image
- Example: `FROM ubuntu:latest`

### RUN

- Executes commands when building the image
- Example:
  dockerfile RUN apt-get update && \ apt-get install -y openjdk-8-jdk

### CMD

- Defines the default command to run when a container starts
- Can be overridden at runtime
- Example: `CMD ["ping", "localhost"]`

### ENTRYPOINT

- Similar to CMD, but cannot be easily overridden
- Makes the container behave like an executable
- Example: `ENTRYPOINT ["echo", "Hello"]`

### ENV

- Sets environment variables in the image
- Example: `ENV JAVA\_HOME /usr/lib/jvm/java-8-openjdk-amd64`

### COPY and ADD

- COPY: Copies files from host to image
- ADD: Similar to COPY, but can also download files from URLs
- Example:
  dockerfile COPY app.war /usr/local/tomcat/webapps/ ADD https://example.com/file.txt /app/

## Advanced Concepts

### Multi-stage Builds

- Allows using multiple FROM statements in a Dockerfile
- Helps reduce final image size
- Example:
  dockerfile FROM openjdk:8-jdk-alpine AS build COPY . /app RUN javac /app/Main.java

FROM openjdk:8-jre-alpine COPY --from=build /app/Main.class /app/ CMD ["java", "-cp", "/app", "Main"]

### Layer Optimization

- Reduce number of layers for better performance
- Combine RUN commands using &&
- Use .dockerignore to exclude unnecessary files

### Copy-on-Write (CoW)

- Docker's storage optimization technique
- Allows efficient use of storage and quick container startup

## Best Practices

- Use specific tags for base images
- Minimize the number of layers
- Use multi-stage builds for smaller final images
- Order Dockerfile commands from least to most frequently changing

## Building and Running Images

- Build: `docker build -t image\_name:tag .`
- Run: `docker run [options] image\_name:tag`

## Real-world Example: Tomcat Application Deployment

dockerfile FROM tomcat:9-jre8-alpine COPY target/myapp.war /usr/local/tomcat/webapps/ EXPOSE 8080 CMD ["catalina.sh", "run"]

Remember to optimize your Dockerfiles for your specific use case and application requirements.
