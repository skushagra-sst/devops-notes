# Terraform in Action

## Class Revision Notes: AWS and Terraform Concepts

This document provides a comprehensive revision of the concepts discussed in the class, focusing on the usage and principles of AWS and Terraform.

## Key Concepts Covered

### 1. Subnets and Their Dependencies

#### Subnets

In AWS, a subnet is a range of IP addresses in your VPC. There are public and private subnets.

**Private Subnets:**
- These are subnets that cannot be directly accessed from the internet
- They do not connect to the internet gateway
- Used for resources that should not be publicly accessible (databases, internal services)
- Typically used for backend infrastructure

**Public Subnets:**
- These subnets are connected to the internet gateway
- Can be accessed from the internet
- Used for resources that need internet access (web servers, load balancers)
- Typically used for frontend infrastructure

#### Implicit Dependencies in Terraform

Terraform understands resource dependencies implicitly. By referencing a resource in another resource block (e.g., AWS subnet), Terraform determines the order of creation.

**Example:**
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id  # Implicit dependency
  cidr_block = "10.0.1.0/24"
}
```

**How it works:**
- Terraform analyzes resource references
- Automatically determines creation order
- Ensures dependencies are created first
- Prevents errors from missing resources

### 2. VPC and Network Configuration

#### Virtual Private Cloud (VPC)

A VPC is a virtual network dedicated to your AWS account. It's logically isolated from other virtual networks in the AWS cloud.

**Key Characteristics:**
- Isolated network environment
- Custom IP address range
- Complete control over network configuration
- Can span multiple Availability Zones

#### CIDR Blocks

CIDR (Classless Inter-Domain Routing) is a set of Internet Protocol (IP) standards used in creating unique identifiers for networks. When creating a VPC, you define its CIDR block to determine the size and IP range.

**Common CIDR Blocks:**
- `/16` - 65,536 IP addresses (10.0.0.0/16)
- `/24` - 256 IP addresses (10.0.1.0/24)
- `/28` - 16 IP addresses (10.0.1.0/28)

**Example:**
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main-vpc"
  }
}
```

#### Routing Tables

Define the rules on how traffic is directed in a VPC. They determine the direction of traffic based on the destination IP.

**Components:**
- Routes: Define where traffic goes
- Route table associations: Link subnets to route tables
- Default route: Usually points to internet gateway or NAT gateway

**Example:**
```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}
```

### 3. Terraform Basics

#### State Management

Terraform uses a state file to keep track of the infrastructure it manages. This file, `terraform.tfstate`, records the state of your managed infrastructure.

**Local State:**
- Stored in `terraform.tfstate` file
- Works for single-user scenarios
- Not suitable for team collaboration

**Remote State:**
When multiple users work on the same infrastructure, it is recommended to maintain a remote state to avoid discrepancies. Using AWS S3 for storing state files and DynamoDB for state locking can help manage shared environments efficiently.

**Benefits of Remote State:**
- Shared state across team members
- State locking prevents conflicts
- Centralized state management
- Backup and versioning

**Example Remote State Configuration:**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

#### Main Terraform Files

**main.tf:**
- Often used to define the primary Terraform configuration
- Contains provider configuration
- Main resource definitions
- Entry point for Terraform

**network.tf:**
- Typically describes network stacks such as VPCs, subnets, and internet gateway connections
- Contains networking resources
- Separates network concerns

**compute.tf:**
- Includes resources like EC2 instances and security groups
- Contains compute resources
- Separates compute concerns

**File Organization Benefits:**
- Better organization
- Easier maintenance
- Clear separation of concerns
- Team collaboration

### 4. Types of IPs

#### Private IPs

Assigned to AWS resources within a VPC. They are reachable only within the same VPC.

**Characteristics:**
- Not routable on the internet
- Used for internal communication
- Automatically assigned by AWS
- Can be manually specified

**Example:**
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  private_ip    = "10.0.1.50"  # Optional private IP
}
```

#### Public IPs

Assigned to resources connected to the internet. These are accessible from outside the AWS cloud.

**Characteristics:**
- Routable on the internet
- Automatically assigned (if enabled)
- Released when instance stops
- Can be disabled for private instances

**Example:**
```hcl
resource "aws_instance" "example" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  associate_public_ip_address = true
}
```

#### Elastic IPs

A persistent public IP address associated with your AWS account. It can be easily reassigned to different resources.

**Characteristics:**
- Persistent across instance stops/starts
- Can be reassigned to different instances
- Charges apply if not attached
- Useful for production workloads

**Example:**
```hcl
resource "aws_eip" "example" {
  instance = aws_instance.example.id
  domain   = "vpc"

  tags = {
    Name = "example-eip"
  }
}
```

### 5. Launching EC2 Instances

You cannot create an EC2 instance without an Amazon Machine Image (AMI). AWS provides several AMIs for different operating systems, which are essential for instance creation.

**AMI Types:**
- Amazon Linux 2
- Ubuntu
- Windows Server
- RHEL
- Custom AMIs

**Finding AMIs:**
- AWS Console
- AWS CLI: `aws ec2 describe-images`
- Data source in Terraform

**Example:**
```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}
```

### 6. Variable Management in Terraform

Terraform allows you to define variables and use them across your configurations.

#### Input Variables

Used to make configurations customizable.

**Example:**
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

**Usage:**
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}
```

#### Output Variables

Useful for displaying information about your infrastructure.

**Example:**
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "instance_public_ip" {
  description = "Public IP address"
  value       = aws_instance.example.public_ip
  sensitive   = false
}
```

#### Local Variables

Limit scope to a particular configuration file.

**Example:**
```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = "MyProject"
    ManagedBy   = "Terraform"
  }
  
  instance_name = "${var.environment}-instance"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = local.common_tags
}
```

## Complete Example: VPC with EC2 Instance

### Network Configuration

```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

### Security Group

```hcl
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}
```

### EC2 Instance

```hcl
resource "aws_instance" "web" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name = "web-server"
  }
}
```

## Best Practices

1. **Use remote state** - S3 + DynamoDB for team collaboration
2. **Organize files** - Separate by concern (network, compute, etc.)
3. **Use variables** - Make configurations reusable
4. **Use locals** - Reduce repetition within files
5. **Tag resources** - Better organization and cost tracking
6. **Use data sources** - Find AMIs dynamically
7. **Validate variables** - Ensure correct input values
8. **Use outputs** - Expose important information
9. **Version providers** - Pin provider versions
10. **Document code** - Add descriptions and comments

## Common Patterns

### Multi-AZ Deployment

```hcl
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}
```

### Conditional Resources

```hcl
resource "aws_instance" "example" {
  count         = var.create_instance ? 1 : 0
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

### Using Data Sources

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}
```

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| State file locked | Check for other Terraform processes |
| Dependency errors | Verify resource references |
| Invalid AMI | Use data source to find AMI |
| Subnet not found | Check VPC and subnet configuration |
| Security group rules | Verify ingress/egress rules |

## Summary

**Key Takeaways:**

1. **Subnets** - Public and private subnets serve different purposes
2. **VPC** - Isolated network environment for AWS resources
3. **CIDR Blocks** - Define IP address ranges
4. **Routing Tables** - Control traffic direction
5. **State Management** - Use remote state for teams
6. **File Organization** - Separate concerns into different files
7. **IP Types** - Private, public, and Elastic IPs
8. **AMIs** - Required for EC2 instance creation
9. **Variables** - Input, output, and local variables
10. **Dependencies** - Terraform handles implicit dependencies

**Through these notes, learners should gain a better understanding of how to structure AWS resources using Terraform, manage dependencies, handle IPs, and maintain an efficient and organized infrastructure. These concepts are fundamental in DevOps practices and cloud management.**

Mastering Terraform with AWS enables:
- Automated infrastructure provisioning
- Consistent deployments
- Team collaboration
- Infrastructure versioning
- Cost optimization
- Scalable architectures
