# Linux Class Notes

## AWS Fundamentals

### AWS Regions - The Global Layer

#### What is a Region?

An AWS Region is a geographically isolated area that contains multiple Availability Zones (AZs). Each region is designed to be independent, providing:

- **Data Sovereignty:** Data stays within the geographic region
- **Fault Tolerance:** Isolation from failures in other regions
- **Low Latency:** Services closer to end users

**Example Regions:**
- US East (N. Virginia) - us-east-1 - North America
- Asia Pacific (Mumbai) - ap-south-1 - India
- Europe (Ireland) - eu-west-1 - Europe

Each region has its own set of resources, including EC2 instances, RDS databases, and S3 buckets. Resources in one region are isolated from resources in other regions.

#### Availability Zones (AZs)

Each Region contains multiple Availability Zones (usually 2-6). An AZ is a physically separate datacenter (or group of datacenters) connected via low-latency links.

**Example Structure:**
```
Region: ap-south-1
├── ap-south-1a (Availability Zone)
├── ap-south-1b (Availability Zone)
└── ap-south-1c (Availability Zone)
```

**Key Points:**
- AZs are physically separated to provide fault tolerance
- They are connected through redundant, low-latency networks
- Deploying across multiple AZs ensures high availability

### VPC (Virtual Private Cloud) Overview

Inside each Region, you create a VPC - an isolated virtual network for your AWS resources. You can create multiple VPCs in a region.

A VPC lets you define:
- **IP Address Ranges (CIDR blocks):** Define the network address space
- **Subnets:** Divide the VPC into smaller network segments
- **Route Tables:** Control traffic routing within the VPC
- **Internet Gateways:** Enable internet access for resources
- **Security Groups / NACLs:** Control inbound and outbound traffic

### Subnets in AWS

#### What is a Subnet?

A Subnet is a smaller network segment inside your VPC. Each Subnet belongs to exactly one Availability Zone. Subnets divide the VPC into logical groups (e.g., public vs private) and you can attach routing rules to control internet access.

#### Subnet Best Practices

1. **Always use multiple AZs for redundancy:** Distribute resources across AZs to avoid single points of failure
2. **Divide subnets into tiers:** Separate public, private, and isolated subnets
3. **Use NAT Gateways for private subnet internet access:** Allow outbound internet access without exposing resources
4. **Reserve enough CIDR space for scaling:** Plan for future growth
5. **Tag subnets clearly:** Use tags like Env=Prod, Tier=Public for organization
6. **Use Route Tables and Security Groups to isolate traffic:** Implement network segmentation

### AWS Fields for EC2 Instance Creation

#### 1. Name & Tags

**Name:** A tag where key = Name and value = whatever you choose. Helps identify the instance later. Optional but strongly recommended.

**Additional Tags:** Add other key/value tags (e.g., Environment=Production, Role=WebServer). These help with organization, cost-allocation, and automation.

#### 2. Application & OS Images (AMI)

**AMI:** The Amazon Machine Image you choose. Contains the OS (e.g., Amazon Linux, Ubuntu, Windows) and possibly applications or configurations.

**Free Tier eligible:** Select an AMI marked as Free Tier eligible if you're in the Free Tier.

**Quick Start / Marketplace / Community:** Categories include quick-start OS images, Marketplace images (paid or free), and community/shared AMIs.

#### 3. Instance Type

**Instance type:** Determines the hardware configuration including number of vCPUs, amount of RAM, network performance, etc. Examples: t3.micro, m5.large.

Choose based on workload requirements:
- CPU-bound workloads
- Memory-bound workloads
- General purpose workloads

Free Tier often restricts to small instance types like t2.micro or t3.micro.

#### 4. Key Pair (Login)

**Key pair name:** Choose an existing key pair or create a new one. Essential for SSH login (Linux) or RDP (Windows).

If you proceed without a key pair (not recommended for production), you may have no way to connect securely.

#### 5. Network Settings

**VPC / Subnet:** Choose which VPC (virtual private cloud) and subnet the instance will be launched into.

**Auto-assign Public IP:** Whether the instance gets a public IPv4 address at launch (makes it reachable from the internet). Default differs for default vs non-default subnet.

**Security Group(s):** Virtual firewall rules for inbound/outbound traffic to/from the instance.

**Network interfaces / secondary interfaces:** Optionally attach additional network interfaces (advanced).

**Subnet type (public/private):** Determines accessibility and routing.

#### 6. Configure Storage

**Root volume + additional volumes:** The AMI defines a base/root volume; you can add more (EBS volumes) or use instance store volumes depending on instance type.

**Volume Type:** For EBS you might choose types like gp3, gp2, io1, io2, st1, etc. These differ in performance, cost, and IOPS.

**Size (GiB):** Specify the size of each volume.

**IOPS / Throughput:** For certain volume types (io1, io2, gp3) you may need to specify IOPS (for high performance) and throughput.

**Delete on termination:** Whether the volume (especially root) is deleted when the instance is terminated. Helps avoid orphan volumes and unnecessary costs.

**Encryption:** Whether the volume is encrypted; if yes, which KMS key to use.

**Device name:** Which device the volume will appear as inside the OS (e.g., /dev/xvda, /dev/sdb).

#### 7. Advanced Details

**IAM instance profile:** The IAM role that will be associated with the instance. Grants permissions to the instance (for example, to read/write to S3, access other AWS services) via the role.

**Shutdown behavior:** Choose whether when you shut down the instance (from within the OS) the instance will stop or terminate.

**Enable termination protection:** Prevents accidental termination of the instance by users via console/CLI; you must disable it before termination.

**Monitoring (detailed CloudWatch monitoring):** By default, EC2 sends metrics to CloudWatch every 5 minutes; you can enable detailed monitoring for 1-minute intervals (incurs cost).

**Placement group:** If you want your instance in a specific placement group (clustered/hpc/partition) for network performance or fault isolation.

**Tenancy:** Default shared hardware or dedicated host/dedicated instance. Choose "Dedicated" if you need hardware isolation.

**User data:** A script or cloud-init content that runs at launch to configure the instance (install packages, bootstrap, etc).

**Elastic GPU / GPU & FPGA options:** If supported, you may choose GPU/accelerated hardware.

**Network performance optimization:** Options such as enhanced networking (ENA), SR-IOV support, etc.

**Boot mode:** UEFI vs legacy BIOS etc (for some OS/hardware combinations).

**Metadata options / IAM instance metadata service version & restrictions:** Configure the version and use of Instance Metadata Service (IMDS) to improve security.

**License options:** For certain OS or software you may specify license types.

**Tag specifications at launch:** Tags for the instance, volumes, network interfaces, etc.

## Linux Fundamentals

### What is Linux?

Linux is an open-source operating system widely used in servers, cloud systems, DevOps pipelines, and automation environments. It provides a stable, secure, and flexible platform for running applications and services.

### Linux Architecture

#### What is Linux Kernel?

The Linux kernel is the core component of the operating system that:
- Manages CPU, memory, devices, and filesystems
- Provides system calls so applications can interact with hardware safely
- Controls process scheduling, networking, and security

Think of it as the "brain" of Linux, running in the background and making everything else work.

#### What is the Shell?

The shell is a command-line interpreter that lets you interact with the Linux kernel. It translates your commands into actions that the kernel can execute.

**Common shells:**
- **bash:** Default in most systems (Bourne Again Shell)
- **zsh:** Z Shell (popular on macOS)
- **sh:** Basic shell
- **fish:** Friendly Interactive Shell

#### Why Learn Shell Commands?

- **Faster automation:** Script repetitive tasks
- **Foundation for DevOps scripting:** Essential for CI/CD pipelines
- **Easier debugging and system navigation:** Direct access to system information

### 1. Basic Linux Commands

These are the foundational commands that help users create, navigate, and manage files/directories.

#### Command: pwd

**Purpose:** Displays the current working directory.

**Syntax:**
```bash
pwd
```

**Example:**
```bash
[user@linux ~]$ pwd
/home/user
```

#### Command: cd

**Purpose:** Change the current directory.

**Syntax:**
```bash
cd [directory_path]
```

**Examples:**
```bash
cd /home/user/Documents    # Move to Documents folder
cd /tmp/                   # Move to /tmp directory
cd ..                      # Move to parent directory
cd ~                       # Move to home directory
cd -                       # Move to previous directory
```

#### Command: mkdir

**Purpose:** Create new directories.

**Syntax:**
```bash
mkdir [directory_name]
```

**Examples:**
```bash
mkdir projects                          # Create single directory
mkdir -p /home/user/code/python        # Create nested directories
mkdir dir1 dir2 dir3                   # Create multiple directories
```

#### Command: rmdir

**Purpose:** Remove empty directories.

**Syntax:**
```bash
rmdir [directory_name]
```

**Example:**
```bash
rmdir old_folder
```

**Note:** Only removes empty directories. Use `rm -r` for directories with content.

#### Command: touch

**Purpose:** Create empty files or update timestamps.

**Syntax:**
```bash
touch [filename]
```

**Example:**
```bash
touch file1.txt
touch file1.txt file2.txt file3.txt    # Create multiple files
```

#### Command: cat

**Purpose:** Display or concatenate file content.

**Syntax:**
```bash
cat [filename]
```

**Examples:**
```bash
cat file1.txt                    # View file contents
cat file1.txt file2.txt         # View both files
cat file1.txt > newfile.txt     # Copy content to new file
cat file1.txt >> existing.txt   # Append content to existing file
```

#### Command: echo

**Purpose:** Print text or write text into files.

**Syntax:**
```bash
echo [text]
```

**Examples:**
```bash
echo "Hello, Linux!"                    # Print text to terminal
echo "Linux Lab" > lab.txt             # Write to file (overwrites)
echo "More text" >> lab.txt            # Append to file
```

#### Command: clear

**Purpose:** Clear the terminal screen.

**Syntax:**
```bash
clear
```

#### Command: history

**Purpose:** Show list of previously executed commands.

**Syntax:**
```bash
history
```

**Example:**
```bash
history                    # Show all commands
history | grep mkdir       # Search for specific commands
!10                        # Execute command number 10 from history
```

### 2. File Management Commands

These commands let you list, find, copy, move, or remove files efficiently.

#### Command: ls

**Purpose:** List directory contents.

**Syntax:**
```bash
ls [options] [directory]
```

**Examples:**
```bash
ls                          # Basic list
ls -l                       # Long list (permissions, owners, etc.)
ls -a                       # Include hidden files
ls -lh                      # Human-readable format
ls -la                      # Long list with hidden files
ls -lt                      # Sort by modification time
ls -R                       # Recursive listing
```

#### Command: cp

**Purpose:** Copy files or directories.

**Syntax:**
```bash
cp [source] [destination]
```

**Examples:**
```bash
cp file1.txt /backup/              # Copy file to directory
cp file1.txt file2.txt             # Copy and rename
cp -r folder1/ /backup/            # Copy directory recursively
cp -p file1.txt /backup/           # Preserve attributes
cp -u file1.txt /backup/           # Update only if source is newer
```

#### Command: mv

**Purpose:** Move or rename files.

**Syntax:**
```bash
mv [source] [destination]
```

**Examples:**
```bash
mv file1.txt /tmp/                 # Move file to directory
mv oldname.txt newname.txt         # Rename file
mv folder1/ /backup/               # Move directory
```

#### Command: rm

**Purpose:** Remove files or directories.

**Syntax:**
```bash
rm [options] [file/directory]
```

**Examples:**
```bash
rm file1.txt                       # Remove file
rm -r temp_folder                  # Remove directory recursively
rm -f file1.txt                    # Force remove (no prompt)
rm -rf folder/                     # Remove directory forcefully
```

**Warning:** Use with caution - there's no recycle bin in Linux! The `-r` flag is required for directories.

#### Command: find

**Purpose:** Search for files and directories.

**Syntax:**
```bash
find [path] [criteria] [action]
```

**Examples:**
```bash
find /home/user -name "*.log"              # Find all .log files
find . -type f -size +50M                  # Find files > 50MB
find /var/log -mtime -7                    # Find files modified in last 7 days
find . -name "*.txt" -exec rm {} \;        # Find and delete files
find /home -user username                  # Find files owned by user
```

#### Command: locate

**Purpose:** Quick file search using a database (faster than find, but requires database update).

**Syntax:**
```bash
locate [pattern]
```

**Example:**
```bash
locate *.log
updatedb                                    # Update the locate database
```

#### Command: du

**Purpose:** Display disk usage of files and directories.

**Syntax:**
```bash
du [options] [path]
```

**Examples:**
```bash
du -sh /var/log/                   # Total size of directory (human-readable)
du -h /home/user                   # Size of each subdirectory
du -ah /home/user                  # All files and directories
du -d 1 /home/user                 # Depth 1 (only immediate subdirectories)
```

#### Command: df

**Purpose:** Display disk space usage of filesystems.

**Syntax:**
```bash
df [options]
```

**Examples:**
```bash
df -h                              # Human-readable format
df -h /                            # Specific filesystem
df -i                              # Show inode usage
```

### 3. Process Management Commands

Processes represent running programs. Understanding how to list, monitor, and control them is vital for DevOps and system administrators.

#### Command: ps

**Purpose:** Display currently running processes.

**Syntax:**
```bash
ps [options]
```

**Examples:**
```bash
ps                                # Current user's processes
ps -ef                            # All processes in system
ps aux                            # Detailed process information
ps aux | grep nginx               # Find specific process
ps -p 1234                        # Process with specific PID
```

#### Command: top

**Purpose:** Real-time system and process monitoring.

**Syntax:**
```bash
top
```

**Usage:**
- Press `q` to quit
- Press `k` to kill a process (enter PID)
- Press `r` to renice a process (change priority)
- Press `h` for help

**Key Information Displayed:**
- CPU usage
- Memory usage
- Running processes
- Load average

#### Command: htop

**Purpose:** Enhanced version of top with color and interactivity (if installed).

**Syntax:**
```bash
htop
```

**Installation:**
```bash
apt install htop -y                # Debian/Ubuntu
yum install htop -y               # RHEL/CentOS
```

#### Command: kill

**Purpose:** Terminate a process using its PID.

**Syntax:**
```bash
kill [signal] [PID]
```

**Examples:**
```bash
kill 1234                         # Send SIGTERM (graceful termination)
kill -9 1234                      # Forcefully terminate (SIGKILL)
kill -15 1234                     # Send SIGTERM explicitly
killall nginx                     # Kill all processes by name
pkill -f "python script.py"       # Kill by pattern
```

**Common Signals:**
- `SIGTERM (15):` Graceful termination
- `SIGKILL (9):` Forceful termination (cannot be ignored)
- `SIGHUP (1):` Hang up signal

#### Command: jobs, bg, fg

**Purpose:** Manage background/foreground jobs.

**Syntax:**
```bash
jobs                              # List background jobs
bg [job_number]                   # Resume job in background
fg [job_number]                   # Bring job to foreground
```

**Examples:**
```bash
sleep 100 &                       # Start job in background
jobs                              # List background jobs
fg %1                             # Bring job 1 to foreground
bg %1                             # Resume job 1 in background
```

### Extended Concept: Permissions and Ownership

#### Key Commands

**chmod:** Change file permissions

**Syntax:**
```bash
chmod [permissions] [file]
```

**Examples:**
```bash
chmod 755 file.sh                 # rwxr-xr-x
chmod +x file.sh                  # Add execute permission
chmod u+x file.sh                 # Add execute for user
chmod 644 file.txt                # rw-r--r--
```

**Permission Numbers:**
- 4 = read (r)
- 2 = write (w)
- 1 = execute (x)
- 7 = read + write + execute (4+2+1)
- 5 = read + execute (4+1)

**chown:** Change file ownership

**Syntax:**
```bash
chown [user]:[group] [file]
```

**Examples:**
```bash
chown user:group file.sh          # Change owner and group
chown user file.sh                # Change owner only
chown -R user:group directory/    # Recursive change
```

**chgrp:** Change group ownership

**Syntax:**
```bash
chgrp [group] [file]
```

**Example:**
```bash
chgrp developers file.sh
```

## Summary

This class covered:

**AWS Fundamentals:**
- AWS Regions and Availability Zones
- VPC and Subnet concepts
- EC2 instance creation fields and configuration options

**Linux Fundamentals:**
- Basic commands for navigation and file creation
- File management commands for copying, moving, and searching
- Process management commands for monitoring and controlling running programs
- Permissions and ownership management

Mastering these concepts provides the foundation for working with cloud infrastructure and Linux-based systems in DevOps environments.
