# Introduction to Infrastructure Provisioning and Terraform

## Revision Notes: Terraform and Infrastructure as Code

## Introduction to Terraform

Terraform is an open-source tool that allows users to manage cloud infrastructure through code, making it easier to automate and control IT resources across multiple service providers like AWS, Azure, and Google Cloud.

### Key Characteristics

- **Platform Agnostic:** Terraform can interact with various cloud providers, allowing for flexibility in managing infrastructure across different platforms
- **Infrastructure as Code (IaC):** Automates infrastructure management using code, ensuring consistency and reducing errors associated with manual configuration
- **Declarative Language:** You describe what you want, Terraform figures out how to create it
- **State Management:** Tracks infrastructure state to manage changes effectively

## Lifecycle Commands in Terraform

Terraform primarily uses four commands in its lifecycle:

### 1. Terraform Init

**Purpose:**
Initializes a working directory containing Terraform configuration files.

**What it does:**
- Downloads necessary modules and providers mentioned in the configurations
- Locks provider versioning to ensure compatibility
- Sets up backend configuration
- Prepares working directory for Terraform operations

**Example:**
```bash
terraform init
```

**Output:**
- Creates `.terraform` directory
- Downloads providers
- Initializes backend

### 2. Terraform Plan

**Purpose:**
Compares the current state of infrastructure with the desired state as defined in the configuration files, generating an execution plan.

**What it does:**
- Shows what will be created, modified, or destroyed
- Helps preview changes without actually applying them
- Prevents unintended modifications
- Validates configuration syntax

**Example:**
```bash
terraform plan
```

**Output:**
- Lists resources to be created
- Shows changes to existing resources
- Indicates resources to be destroyed
- Provides resource count summary

### 3. Terraform Apply

**Purpose:**
Executes the changes required to reach the desired state of the configuration.

**What it does:**
- Creates, modifies, or destroys infrastructure
- Ensures infrastructure is modified in a controlled manner based on the plan generated
- Updates state file after successful changes
- Requires confirmation (unless auto-approve flag is used)

**Example:**
```bash
terraform apply
```

**Output:**
- Creates resources in cloud provider
- Updates state file
- Shows resource outputs

### 4. Terraform Destroy

**Purpose:**
Removes all configurations defined in Terraform files, cleaning up infrastructure.

**What it does:**
- Destroys all resources managed by Terraform
- Removes infrastructure from cloud provider
- Updates state file
- Requires confirmation

**Example:**
```bash
terraform destroy
```

**Warning:** This permanently deletes infrastructure. Use with caution.

## Advantages of Using Terraform

### Speed and Efficiency

- Automates the process of creating and updating infrastructure
- Significantly reduces the time and cost compared to manual processes
- Enables rapid infrastructure provisioning

### Consistency

- Ensures uniformity across provisioning
- Reduces discrepancies typical of manual configuration
- Same configuration produces same infrastructure

### Version Control

- Terraform scripts can be maintained in version control systems like Git
- Allows for easy rollback and audit of changes
- Enables collaboration and code review
- Provides history of infrastructure changes

### Multi-Cloud Support

- Manage infrastructure across multiple cloud providers
- Avoid vendor lock-in
- Use best services from different providers

### Idempotency

- Running same configuration multiple times produces same result
- Safe to re-run configurations
- Prevents duplicate resources

## Supporting Tools and Concepts

### Configuration Management Tools

Complementary tools such as Ansible, Puppet, and Chef can be used alongside Terraform for managing software configurations and updates on infrastructure.

**Terraform vs Configuration Management:**
- **Terraform:** Provisions infrastructure (servers, networks, storage)
- **Ansible/Puppet/Chef:** Configures software on existing infrastructure

**They work together:**
- Terraform creates infrastructure
- Configuration management tools configure applications

### Server Templating Tools

Vagrant and Docker allow the creation of virtual environments and containerized services, supporting the infrastructure managed by Terraform.

**Vagrant:**
- Creates reproducible development environments
- Works with Terraform for local testing
- Useful for development and testing

**Docker:**
- Containerization platform
- Can be managed with Terraform
- Complements infrastructure provisioning

## Practical Demonstration

### Example Use Case: Creating an EC2 Instance

**Step 1: Define Infrastructure**

Create `main.tf`:
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
```

**Step 2: Initialize Terraform**

```bash
terraform init
```

**Step 3: Plan Changes**

```bash
terraform plan
```

**Step 4: Apply Configuration**

```bash
terraform apply
```

**Step 5: Verify Resources**

```bash
terraform show
```

**Step 6: Destroy Resources (when done)**

```bash
terraform destroy
```

## Terraform Configuration Files

### Main Configuration File

**`main.tf`:**
- Primary configuration file
- Contains resource definitions
- Defines provider configuration

### Variables File

**`variables.tf`:**
- Defines input variables
- Makes configuration reusable
- Enables parameterization

**Example:**
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

### Outputs File

**`outputs.tf`:**
- Defines output values
- Exposes important information
- Used for integration with other tools

**Example:**
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}
```

### Terraform State

**`.tfstate` file:**
- Stores current state of infrastructure
- Maps configuration to real resources
- Used for planning and updates

**Best Practices:**
- Store state remotely (S3, Terraform Cloud)
- Enable state locking
- Never commit state files to Git
- Use state backends

## Terraform Providers

**Providers are plugins:**
- AWS Provider
- Azure Provider
- Google Cloud Provider
- Kubernetes Provider
- Docker Provider
- Many more...

**Example:**
```hcl
provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
```

## Terraform Modules

**Modules are reusable configurations:**
- Organize and reuse code
- Create abstractions
- Share best practices

**Example:**
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  environment = "production"
}
```

## Best Practices

1. **Use version control** - Track all Terraform files
2. **Store state remotely** - Use backends (S3, Terraform Cloud)
3. **Use variables** - Make configurations reusable
4. **Modularize code** - Create reusable modules
5. **Use workspaces** - Manage multiple environments
6. **Validate before apply** - Always run `terraform plan`
7. **Document code** - Add descriptions and comments
8. **Use .tfvars files** - Separate configuration from code
9. **Enable state locking** - Prevent concurrent modifications
10. **Review changes** - Always review plan before applying

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Provider not found | Run `terraform init` |
| State file locked | Check for other Terraform processes |
| Credentials missing | Configure provider credentials |
| Resource already exists | Import existing resource |
| State file out of sync | Run `terraform refresh` |

## Terraform vs Other Tools

### Terraform vs CloudFormation

**Terraform:**
- Multi-cloud support
- HCL language
- Open source

**CloudFormation:**
- AWS only
- JSON/YAML
- AWS native

### Terraform vs Ansible

**Terraform:**
- Infrastructure provisioning
- Declarative
- State management

**Ansible:**
- Configuration management
- Procedural
- Agentless

## Summary

**Key Takeaways:**

1. **Terraform is an IaC tool** - Infrastructure as Code
2. **Four main commands** - init, plan, apply, destroy
3. **Platform agnostic** - Works with multiple cloud providers
4. **State management** - Tracks infrastructure state
5. **Version control** - Infrastructure changes tracked in Git
6. **Speed and consistency** - Faster and more reliable than manual
7. **Modular and reusable** - Create reusable modules

**Terraform is a powerful tool for modern infrastructure management, promoting best practices in deployment through its robust IaC capabilities. It provides speed, consistency, and a clear audit trail through version control, making it an essential component of DevOps practices.**

Mastering Terraform enables:
- Automated infrastructure provisioning
- Multi-cloud management
- Infrastructure versioning
- Consistent deployments
- Reduced manual errors
- Faster time to market
