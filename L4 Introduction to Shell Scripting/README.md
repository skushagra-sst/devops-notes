# DevOps Class Notes

## Linux Basics Review

- Reviewed basic Linux commands like pwd, cd, mkdir, rmdir, rm -rf
- Discussed differences between rmdir and rm -rf
- Covered file manipulation commands like cat, echo, redirection (> and >>)
- Reviewed command history and searching with Ctrl+R
- Discussed file permissions and chmod command

## Advanced Linux Topics

- Introduced Access Control Lists (ACLs) with setfacl and getfacl commands
- Covered the find command for searching files
- Discussed process management commands like ps and kill

## Shell Scripting

### Basic Script Structure

bash

!/bin/bash
Your code here

### Variables and Parameters

- Variables are defined without spaces: `VARIABLE=value`
- Command line parameters: $1, $2, etc. $0 is the script name
- $# gives the number of parameters

### Example Scripts

1. Hello World with parameter:
   bash

!/bin/bash
echo "Hello, $1!"

2. File Checker:
   bash

!/bin/bash
read -p "Enter the file name: " file

if [ -f "$file" ]; then echo "File exists" else echo "File does not exist" fi

3. Uppercase Converter:
   bash

!/bin/bash
read -p "Enter the string in lowercase: " lower

echo "Uppercase: ${lower^^}"

4. Create User and Group:
   bash

!/bin/bash
USERNAME=1GROUPNAME=2

groupadd GROUPNAMEuseradd−m−s/bin/bash−GGROUPNAME $USERNAME

echo "echo Welcome USERNAME">>/home/USERNAME/.bashrc

### Industry Standard Practices

- Include a header with script information (owner, version, etc.)
- Add error handling and input validation
- Use functions for better organization

Example of improved create user script:
bash

!/bin/bash
Owner: Your Name
Email: your.email@example.com
Description: Create a user and add to a group
Revision History
Version Description
0.1 Draft version
1.0 Baselined version
set -e

Check if root user is executing the script
if [[$EUID -ne 0]]; then echo "This script requires root or sudo privileges" exit 1 fi

Check if correct number of parameters are passed
if [[# -ne 2]]; then echo "Usage: 0 username groupname" exit 1 fi

USERNAME=1GROUPNAME=2

groupadd GROUPNAMEuseradd−m−s/bin/bash−GGROUPNAME $USERNAME

echo "echo Welcome USERNAME">>/home/USERNAME/.bashrc

echo "User USERNAMEcreatedandaddedtogroupGROUPNAME"

## Final Project Guidelines

- Create a GitHub project implementing CI/CD pipeline
- Deploy to Kubernetes cluster
- Prepare for viva questions on implementation choices
- Focus on communication skills, correctness, and troubleshooting abilities
- Work in groups but maintain individual repositories
- Be prepared to present and defend any group member's project
