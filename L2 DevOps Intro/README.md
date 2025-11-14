# DevOps Class Summary

## Introduction to DevOps

- DevOps is a set of practices, cultural philosophies, and tools that combine software development and IT operations.
- It aims to deliver applications and services faster and more reliably.
- The most challenging part of DevOps is often the cultural and philosophical aspects, not the technical tools.

## SDLC (Software Development Life Cycle)

1. Planning and Requirement Analysis
2. Design
3. Coding
4. Testing
5. Release
6. Maintenance

## DevOps Lifecycle

1. Planning Phase
   - Identify set of tools (e.g., Terraform, Docker, Kubernetes)
2. Coding Phase
   - Code the application
   - Prepare for delivery (e.g., Dockerfiles, package.json)
3. Build Phase
   - Create artifacts (e.g., libraries, JARs, WARs, executables, Docker images)
4. Testing Phase
   - Functional testing
   - Integration testing
   - System testing
   - Linting
   - Security testing (DevSecOps)

## Shift Left Approach

- Catch bugs and issues as early as possible in the development process
- Reduces cost and time to fix issues

## Types of Security Testing

1. SCA (Software Composition Analysis)
   - Checks for vulnerabilities in software dependencies and versions
2. SAST (Static Application Security Testing)
   - Analyzes source code for potential security vulnerabilities
3. DAST (Dynamic Application Security Testing)
   - Tests running applications for security vulnerabilities

## Continuous Integration (CI) Pipeline

1. Download code (e.g., Git clone)
2. Install dependencies
3. Lint the code
4. Build/Compile the code
5. Run unit tests
6. Perform SCA
7. Perform SAST
8. Create Docker image (if applicable)
9. Validate Docker image
10. Push artifacts to repository (e.g., JFrog Artifactory)

## Project Requirements

- Implement a CI pipeline for your project
- Use various tools and techniques discussed in class
- Be prepared to explain your choices in the viva
