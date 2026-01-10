# CI/CD with Kubernetes - Adding Agent and Implementing CD

## Introduction

This class addresses the deployment of applications into a Kubernetes cluster, focusing on Continuous Integration (CI) and Continuous Deployment (CD), which are critical components in modern DevOps environments.

## Continuous Integration (CI) and Continuous Deployment (CD)

### Continuous Integration (CI)

**Definition:**
It involves the process of automating the integration of code changes from multiple contributors into a single project.

**Key Objectives:**
- Frequent code merges
- Automated testing
- Ensuring the mainline code base remains in a deployable state

**Benefits:**
- Early bug detection
- Reduced integration problems
- Faster feedback loops
- Improved code quality

### Continuous Deployment (CD)

**Definition:**
CD extends the automation to deploying changes to a production environment. It involves infrastructure configuration and deployment mechanisms to provide updates to applications without downtime.

**Key Characteristics:**
- Automated deployment to production
- Infrastructure as code
- Zero-downtime deployments
- Rollback capabilities

**Difference from CI:**
- CI focuses on building and testing
- CD focuses on deployment and infrastructure

## Setting Up a Kubernetes Environment

### Creating a Virtual Machine

**Requirements:**
- At least one node Kubernetes cluster is necessary
- Tools like VirtualBox and Vagrant can be used to set this up

**Vagrant Scripts:**
- Help automate the creation of virtual environments
- Simplify the process by allowing users to copy-paste scripts
- Create virtual environments with necessary configurations

**Benefits:**
- Reproducible environments
- Easy setup and teardown
- Consistent development environments

### Deploying on Kubernetes

**Prerequisites:**
- Ensure that Kubernetes is pre-installed on your VM
- Using an existing Amazon Machine Image (AMI) with pre-installed Kubernetes is a viable shortcut

**Steps:**
1. Create or use existing VM with Kubernetes
2. Configure kubectl to connect to cluster
3. Verify cluster connectivity
4. Deploy applications

## GitHub Actions and Custom Runners

### GitHub Actions

**Definition:**
Automates your CI/CD workflows directly in your repository. It allows you to build, test, package, release, and deploy code directly on GitHub.

**Features:**
- Workflow automation
- Integration with GitHub
- Extensive action marketplace
- Free for public repositories

### Custom Runners

**Definition:**
Instead of using GitHub-hosted runners, you can set up self-hosted runners. This involves configuring your machine (Linux recommended) as a runner, which then can be registered in GitHub and utilized for your workflows.

**Benefits:**
- More control over environment
- Access to private resources
- Custom configurations
- Cost savings for large workloads

### Configuration

**Setup Steps:**

1. **Use config.sh to register the runner:**
   ```bash
   ./config.sh --url https://github.com/OWNER/REPO --token TOKEN
   ```

2. **Set up the runner with necessary labels:**
   ```bash
   ./config.sh --labels self-hosted,linux,x64
   ```

3. **Security configurations:**
   - Limit runner access
   - Use proper authentication
   - Secure network access

**Runner Registration:**
- Download runner package from GitHub
- Extract and configure
- Run as a service
- Verify in GitHub Actions settings

## CI/CD Pipeline with Kubernetes

### Pipeline Stages

**CI Stage:**
1. Checkout code
2. Build application
3. Run tests
4. Build Docker image
5. Push to registry

**CD Stage:**
1. Deploy to Kubernetes
2. Update deployments
3. Verify deployment
4. Rollback if needed

### Kubernetes Deployment

**Deployment Methods:**
- kubectl apply
- Helm charts
- ArgoCD
- Flux

**Example Workflow:**
```yaml
- name: Deploy to Kubernetes
  run: |
    kubectl set image deployment/myapp \
      myapp=${{ secrets.DOCKERHUB_USERNAME }}/myapp:${{ github.sha }}
    kubectl rollout status deployment/myapp
```

## Project Demonstration and Teamwork

**Project Requirements:**
- Each team forms a project and presents it
- The project involves implementing CI/CD for the application using GitHub Actions amongst other tools
- Collaboration is required, but each individual is responsible for their unique contributions

**Key Points:**
- Individual accountability
- Team collaboration
- Presentation skills
- Technical implementation

## Testing and Quality Assurance

### Structured Testing Approach

**Environments:**
- **System Integration Testing (SIT):** Tests system components together
- **Performance Testing:** Validates performance under load
- **Security Testing:** Identifies security vulnerabilities

**Testing Phases:**
- Unit tests
- Integration tests
- End-to-end tests
- Performance tests
- Security scans

**Automation:**
- Testing phases are often automated to minimize human error
- Ensures comprehensive test coverage
- Provides consistent results

## Practical Considerations

### CI and CD Separation

**Best Practice:**
CI and CD are usually separate processes in well-structured environments to maintain clear separation of concerns.

**Benefits:**
- Independent scaling
- Different security requirements
- Separate rollback strategies
- Clear responsibility boundaries

### Pipeline Configuration

**Tailoring:**
Continuous deployment pipelines may require specific configurations tailored to your application's demands and the hosting infrastructure.

**Considerations:**
- Application type
- Infrastructure requirements
- Security policies
- Compliance needs
- Team preferences

## Custom Runner Setup Guide

### Step 1: Download Runner

```bash
# Create a folder
mkdir actions-runner && cd actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
```

### Step 2: Configure Runner

```bash
# Configure the runner
./config.sh --url https://github.com/OWNER/REPO \
  --token TOKEN \
  --labels self-hosted,linux,x64 \
  --name my-runner
```

### Step 3: Install as Service

```bash
# Install as a service
sudo ./svc.sh install

# Start the service
sudo ./svc.sh start

# Check status
sudo ./svc.sh status
```

### Step 4: Use in Workflow

```yaml
jobs:
  deploy:
    runs-on: self-hosted
    steps:
    - name: Deploy to Kubernetes
      run: kubectl apply -f k8s/
```

## Kubernetes Deployment Strategies

### Rolling Update

**Default strategy:**
- Gradually replaces old pods with new ones
- Zero downtime
- Automatic rollback on failure

### Blue-Green Deployment

**Strategy:**
- Deploy new version alongside old
- Switch traffic when ready
- Instant rollback capability

### Canary Deployment

**Strategy:**
- Deploy to small subset first
- Monitor and validate
- Gradually roll out to all

## Best Practices

1. **Use custom runners for Kubernetes access** - Direct cluster access
2. **Separate CI and CD stages** - Clear boundaries
3. **Implement proper testing** - Multiple test levels
4. **Use secrets for credentials** - Never hardcode
5. **Monitor deployments** - Track success/failure
6. **Implement rollback strategies** - Quick recovery
7. **Version control everything** - Infrastructure as code

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Runner not connecting | Check network and token |
| kubectl not found | Install kubectl on runner |
| Permission denied | Configure RBAC properly |
| Deployment fails | Check resource limits |
| Image pull errors | Configure image pull secrets |

## Summary

**Key Takeaways:**

1. **CI focuses on integration and testing** - Build and validate
2. **CD focuses on deployment** - Automate releases
3. **Custom runners provide flexibility** - Self-hosted options
4. **Kubernetes enables scalable deployments** - Container orchestration
5. **Testing is critical** - Multiple test levels
6. **Separation of concerns** - CI and CD are separate
7. **Infrastructure as code** - Version control everything

**This concludes the revision notes for the class covering CI/CD processes involving Kubernetes setup and deployment strategies.**

Mastering CI/CD with Kubernetes enables automated, reliable, and scalable application deployments in production environments.
