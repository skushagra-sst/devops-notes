# DevOps Class Summary: AWS EC2 and Linux Basics

## 1. Review of Previous Class

- Continuous Integration (CI) pipeline steps:
  1. Code check-in triggers pipeline
  2. Linting
  3. Build (including package management)
  4. Unit testing
  5. Software Compliance Analysis (SCA)
  6. Static Analysis Security Testing (SAST)
  7. Dockerization (creating Docker images)
  8. Push image to artifact repository

## 2. Introduction to Linux

- Linux is an open-source operating system created by Linus Torvalds in 1991
- Over 90% of production environments run on Linux
- Various distributions (distros) of Linux exist, some free (e.g., Ubuntu) and some paid (e.g., Red Hat)

## 3. Linux Kernel

- Heart of the operating system
- Acts as an interface between hardware and software
- Manages CPU, memory, and other resources
- Uses microkernel architecture allowing for driver installations

## 4. AWS EC2 (Elastic Compute Cloud)

- Service for creating and managing virtual machines in the cloud
- Key concepts:
  - Regions and Availability Zones
  - VPC (Virtual Private Cloud)
  - Subnets (public and private)
  - Security Groups
  - AMI (Amazon Machine Image)
  - Instance types and sizes

## 5. IP Addresses in AWS

- Three types:
  1. Public IP: Accessible from outside AWS
  2. Private IP: For internal AWS communication
  3. Elastic IP: Static public IP that can be reassigned

## 6. Creating an EC2 Instance

- Steps to create an EC2 instance:
  1. Choose AMI (e.g., Ubuntu)
  2. Select instance type (e.g., t2.micro)
  3. Configure network settings (VPC, subnet, public IP)
  4. Add storage
  5. Configure security group
  6. Create or select key pair for SSH access

## 7. Connecting to EC2 Instance

- Use SSH with the key pair (.pem file)
- Command: `ssh -i <key-pair.pem> ubuntu@<public-ip>`
- Ensure proper permissions on the key file (e.g., chmod 600)

## 8. Additional Concepts

- Spot Instances: Cost-effective but can be terminated by AWS
- Security Groups: Control inbound and outbound traffic
- Docker installation on EC2

## 9. Next Steps

- Further exploration of Linux commands
- Understanding file permissions and user management
- Deeper dive into AWS services and best practices
