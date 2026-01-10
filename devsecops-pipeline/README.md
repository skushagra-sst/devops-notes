# Introduction to DevSecOps and Implementing It

## Complete CI Tutorial: GitHub Actions DevSecOps Pipeline (Java + Docker)

This tutorial explains how to design, implement, and understand a real-world CI pipeline using GitHub Actions with DevSecOps principles.

**By the end, you will understand:**
- How CI works in GitHub Actions
- Why each stage exists
- How security is integrated (DevSecOps)
- How Docker images are built, tested, scanned, and pushed

## What Are We Building?

We are building a production-style Continuous Integration pipeline that automatically:
- Pulls source code
- Builds a Java application
- Runs linting and unit tests
- Performs code security scanning (SAST)
- Performs dependency scanning (SCA)
- Builds a Docker image
- Scans the container for vulnerabilities
- Runs the container and tests it
- Pushes a verified image to DockerHub

## CI Architecture Overview

```
Developer Push → GitHub Actions Runner →
Checkout → Build → Test → Security Scan →
Docker Build → Image Scan → Container Test → Push to Registry
```

This pipeline follows DevSecOps principles — security is applied before the software is shipped.

## Prerequisites

### Before Using This Pipeline, You Need:

**Application:**
- Java Maven project
- Working Dockerfile
- App running on port 8080

**DockerHub Account:**
- Create DockerHub username
- Create DockerHub access token

### GitHub Secrets (Mandatory)

Go to:
**GitHub Repo → Settings → Secrets and variables → Actions → New repository secret**

Create:

| Secret Name | Value |
|-------------|-------|
| `DOCKERHUB_USERNAME` | your_dockerhub_username |
| `DOCKERHUB_TOKEN` | dockerhub_access_token |

These secrets securely authenticate your pipeline.

## Pipeline Trigger

```yaml
on:
  push:
    branches:
      - master
  workflow_dispatch:
```

**What this does:**
- Runs automatically on every push to master
- Can also be run manually from GitHub UI

This enables continuous integration.

## Job Configuration

```yaml
jobs:
  ci-pipeline:
    runs-on: ubuntu-latest
```

Your entire CI runs on a fresh Linux virtual machine provided by GitHub.

## Permissions

```yaml
permissions:
  contents: read
  security-events: write
```

This allows the pipeline to:
- Read source code
- Upload vulnerability reports to GitHub Security tab

## Pipeline Stages Explained

### 1. Checkout Source Code

```yaml
- uses: actions/checkout@v4
```

**Downloads your repository into the runner.**

Without this step → nothing to build.

### 2. Setup Java

```yaml
- uses: actions/setup-java@v3
```

**Installs:**
- Java 11
- Maven
- Dependency caching

**Speeds up builds and ensures version consistency.**

### 3. Linting (Code Quality)

```yaml
- name: Linting
  run: mvn checkstyle:check
  continue-on-error: true
```

**Purpose:**
- Enforces coding standards
- Detects bad practices early

**`continue-on-error: true` means:**
- Pipeline continues
- But violations are visible

**Used to control technical debt.**

### 4. SAST – CodeQL

```yaml
- uses: github/codeql-action/init@v2
- uses: github/codeql-action/analyze@v2
```

**Detects:**
- SQL injection
- Command injection
- Insecure deserialization
- OWASP Top 10 issues

**This scans source code itself.**

**Prevents insecure code from entering production.**

### 5. SCA – OWASP Dependency Check

```yaml
- uses: dependency-check/Dependency-Check_Action@main
```

**Finds vulnerabilities in:**
- Maven libraries
- Open-source dependencies

**Protects against supply chain attacks.**

### 6. Unit Testing

```yaml
- name: Unit Tests
  run: mvn test
```

**Validates:**
- Business logic
- Functional correctness

**Pipeline fails if tests fail.**

**Prevents broken builds.**

### 7. Build Application

```yaml
- name: Build Application
  run: mvn clean package -DskipTests
```

**Creates:**
- Compiled JAR/WAR
- Ready for Docker packaging

**Separates testing from packaging.**

### 8. Docker Image Build

```yaml
- name: Build Docker Image
  run: docker build -t username/test:latest .
```

**Creates immutable application image.**

**This ensures environment consistency.**

### 9. Trivy Image Scan

```yaml
- uses: aquasecurity/trivy-action@master
  with:
    image-ref: username/test:latest
    exit-code: 1
```

**Detects vulnerabilities in:**
- Linux OS packages
- Java libraries
- CVEs

**`exit-code: 1` → pipeline fails if critical/high vulnerabilities exist.**

**Prevents insecure containers from being shipped.**

### 10. Upload Scan Results

```yaml
- uses: github/codeql-action/upload-sarif@v2
```

**Uploads Trivy findings to:**
- GitHub → Security → Code scanning alerts

**Enables centralized vulnerability tracking.**

### 11. Container Runtime Testing

```yaml
- name: Container Test
  run: |
    docker run -d -p 8080:8080 username/test:latest
    sleep 10
    curl http://localhost:8080
```

**Verifies:**
- Container boots
- App responds
- No runtime crash

**This is a smoke test.**

### 12. DockerHub Login

```yaml
- uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```

**Uses secrets to authenticate securely.**

**Prevents hard-coding credentials.**

### 13. Push Docker Image

```yaml
- name: Push Docker Image
  run: docker push username/test:latest
```

**Publishes trusted image.**

**Enables deployment pipelines (CD).**

## What Happens When Code is Pushed?

1. Developer pushes code
2. GitHub Actions spins up VM
3. Code is built & tested
4. Security scans execute
5. Docker image is built
6. Image is scanned
7. Container tested
8. Image pushed if all checks pass

## DevOps & Security Concepts Demonstrated

- **Continuous Integration:** Automated build and test
- **Shift-left security:** Security checks early in pipeline
- **DevSecOps:** Security integrated into DevOps
- **Supply chain protection:** Dependency scanning
- **Immutable artifacts:** Docker images
- **Quality gates:** Fail pipeline on issues
- **Infrastructure-as-code:** Pipeline as code
- **Zero-trust credentials:** Secrets management

## What Makes This Pipeline "Industry-Grade"?

- Multi-layered security
- Code + dependency + container scanning
- Failing on critical vulnerabilities
- Runtime verification
- Artifact promotion
- Secure secrets handling
- GitHub Security integration

## Recommended Extensions

- Add SonarQube quality gates
- Add SBOM generation
- Push to AWS ECR
- Add CD to EKS/ECS
- Slack alerts
- Artifact versioning
- Infrastructure pipeline

## Security Scanning Tools

### SAST (Static Application Security Testing)

**CodeQL:**
- GitHub's code analysis engine
- Detects security vulnerabilities in source code
- Supports multiple languages

**Benefits:**
- Finds issues before deployment
- No runtime required
- Integrated with GitHub

### SCA (Software Composition Analysis)

**OWASP Dependency Check:**
- Scans dependencies for known vulnerabilities
- Checks against CVE database
- Generates detailed reports

**Benefits:**
- Protects against supply chain attacks
- Identifies outdated dependencies
- Prevents vulnerable libraries

### Container Scanning

**Trivy:**
- Comprehensive container scanner
- Detects OS and application vulnerabilities
- Fast and easy to use

**Benefits:**
- Scans final artifact
- Detects runtime vulnerabilities
- Integrates with CI/CD

## Best Practices

1. **Fail fast:** Stop pipeline on critical issues
2. **Use secrets:** Never hardcode credentials
3. **Cache dependencies:** Speed up builds
4. **Version images:** Tag with commit SHA or version
5. **Scan everything:** Code, dependencies, containers
6. **Test containers:** Verify runtime behavior
7. **Upload results:** Centralize security findings

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| DockerHub authentication fails | Check secrets are set correctly |
| Trivy finds vulnerabilities | Update base image or dependencies |
| Tests fail | Fix failing tests before proceeding |
| CodeQL timeout | Increase timeout or optimize queries |
| Dependency check slow | Cache dependency check results |

## Summary

**Key Takeaways:**

1. **DevSecOps integrates security** into every stage of CI/CD
2. **Multiple security layers** provide defense in depth
3. **Automated scanning** catches issues early
4. **Quality gates** prevent bad code from progressing
5. **Immutable artifacts** ensure consistency
6. **Secrets management** protects credentials
7. **Security findings** are centralized and trackable

**Final Takeaway:**

This pipeline is not "just CI." It is a DevSecOps quality gate system that ensures:
- Only tested, scanned, verified, and trusted software is allowed to move forward
- Security is built-in, not bolted on
- Vulnerabilities are caught before production
- Compliance and audit trails are maintained

Mastering DevSecOps pipelines enables secure, automated software delivery in production environments.
