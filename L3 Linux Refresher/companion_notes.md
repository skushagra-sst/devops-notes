# Comprehensive Notes on Software Engineering Class

## Introduction to CI/CD

### What is CI/CD?

CI/CD stands for Continuous Integration and Continuous Deployment, a critical practice in modern software development. It involves the automatic building, testing, and deploying of applications to ensure that changes to the codebase are quickly integrated and deployed with minimal manual intervention.

### Continuous Integration (CI)

- **Code Repository**: When a user checks in code into a repository, it triggers an automated pipeline【6:5†transcript.txt】.
- **Pipeline Steps**:
  1. **Linting**: Ensuring code quality by checking for syntax errors. Although some organizations may skip this, it's a best practice to include it to catch any missed errors before the build stage【6:5†transcript.txt】.
  2. **Building**: This stage includes downloading necessary packages and can also include unit testing if configured to do so【6:9†transcript.txt】.
  3. **Unit Testing**: Involves testing individual parts or units of an application. To facilitate unit testing, a concept called 'mocking' is often used, especially when testing functions that rely on external calls【6:7†transcript.txt】.
  4. **SCA and SAST**: Software Compliance Analysis (SCA) and Static Analysis Security Testing (SAST) are crucial for ensuring that the code adheres to security standards and does not include known vulnerabilities【6:2†transcript.txt】.

### Artifacts in CI

- Artifacts are binary files generated during the build process. Depending on the programming language, they could be in the form of jars, wars, gems, exes, or Docker images. These artifacts are crucial for testing and deployment【6:0†transcript.txt】【6:4†transcript.txt】.

## Introduction to Containers and Docker

### Dockerization

- Docker involves packaging applications into containers. A Docker image is a static artifact that can be deployed to various environments【6:9†transcript.txt】.
- **Creating Docker Images**: Starting from a base image, additional layers which contain your application are added. Each layer is cached to save time during the build process【6:2†transcript.txt】.

### Pushing Docker Images

- After creating Docker images, they are pushed to an artifact repository for storage and version control【6:4†transcript.txt】.

## Continuous Deployment (CD)

### Deployment Pipeline

- **Artifacts Deployment**: The deployment begins from the artifact repository. It can be an independent pipeline or a continuation from CI【6:6†transcript.txt】.
- **System Integration Testing (SIT)**: This is the initial platform where the application is deployed for testing its interactions with other systems. It tests the application from a holistic perspective rather than in isolation【6:0†transcript.txt】.

### Elastic and Public IPs in Deployment

- **Public IPs**: These are temporarily assigned IPs that change when an instance is stopped or started【6:3†transcript.txt】.
- **Elastic IPs**: Unlike public IPs, elastic IPs remain constant even when an instance is rebooted or stopped. They are useful for maintaining fixed endpoints in a production environment【6:3†transcript.txt】.

## Summary

- **CI/CD** significantly automates the integration and deployment process, reducing friction between development and operations.
- **Docker** and containerization play a critical role in modern application deployment, offering portability and lightweight execution environment【6:2†transcript.txt】.
- **Elastic IPs** play a key role in maintaining stable hostname for applications that are frequently rebooted or redeployed【6:3†transcript.txt】.

Understanding and implementing CI/CD and Dockerization can lead to a robust software delivery pipeline that enhances productivity and quality assurance practices.
