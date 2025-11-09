# Shell Scripting Notes

## Introduction

Shell scripting is a powerful way to automate tasks in Linux/Unix systems. Scripts are text files containing commands that are executed by a shell interpreter.

## 1. Hello World Shell Script

### Basic Script

```bash
#!/bin/bash
# This is a simple shell script that prints "Hello, World!" to the terminal
echo "Hello, World!"
```

### Shebang Explained

The `#!/bin/bash` line is called the **shebang** (pronounced "sha-bang"). It tells the system to use the Bash shell (located at `/bin/bash`) to interpret and execute all commands in this script.

### Other Common Shebang Options

| Shebang | Interpreter | Use Case |
|---------|-------------|----------|
| `#!/bin/bash` | Bash shell | Most common; full-featured scripting shell |
| `#!/bin/sh` | Basic shell (often linked to dash on Ubuntu) | Faster, POSIX-compliant, but lacks some Bash features |
| `#!/usr/bin/env bash` | Finds Bash from the user's $PATH | More portable across systems where Bash may not be in /bin/ |
| `#!/bin/zsh` | Z shell | Used if you prefer Zsh scripting features |
| `#!/usr/bin/python3` | Python interpreter | Used for Python scripts |
| `#!/usr/bin/perl` | Perl interpreter | Used for Perl scripts |

## 2. Basic Shell Scripts

### Display Current Date and Time

**Purpose:** Show the current system date and time.

**Key Concepts:**
- Command substitution using `$(command)`
- The `date` command

### Check Disk Usage

**Purpose:** Display disk space usage for all mounted filesystems.

**Key Concepts:**
- The `df -h` command (human-readable format)

### List Files in a Directory

**Purpose:** List files in the current directory with detailed information.

**Key Concepts:**
- The `ls -l` command for long format listing

### Check if a File Exists

**Purpose:** Verify if a file exists before performing operations.

**Key Concepts:**
- Conditional statements with `if [ -f "$file" ]`
- File test operators (`-f` for file, `-d` for directory)
- User input with `read -p`

### Add Two Numbers

**Purpose:** Perform arithmetic operations in shell scripts.

**Key Concepts:**
- Arithmetic expansion: `$((expression))`
- Variable assignment and arithmetic operations

### Print System Uptime

**Purpose:** Display how long the system has been running.

**Key Concepts:**
- The `uptime -p` command for human-readable uptime

### Check User Login

**Purpose:** Verify if a user exists on the system.

**Key Concepts:**
- The `id` command to check user existence
- Redirecting output to `/dev/null` to suppress messages
- Exit status checking

### Backup a Directory

**Purpose:** Create a compressed backup of a directory with timestamp.

**Key Concepts:**
- The `tar` command for archiving
- Timestamp generation with `date +%F`
- Creating compressed archives with `tar -czf`

### Check Internet Connectivity

**Purpose:** Test if the system has internet connectivity.

**Key Concepts:**
- The `ping` command
- Conditional checking with exit status
- Redirecting output with `&>/dev/null`

### Find the Length of a String

**Purpose:** Calculate the number of characters in a string.

**Key Concepts:**
- Parameter expansion: `${#variable}` returns string length

## 3. String Manipulation

### Parameter Expansion

In Bash, variables are referenced using `${variable_name}`. `${str}` retrieves the value stored in the variable `str`.

**Example:**
```bash
str="hello"
echo ${str}
# Output: hello
```

### Case Conversion

Bash 4+ provides special syntax for case conversion:

| Expression | Description | Example |
|------------|-------------|---------|
| `${var^}` | Converts first character to uppercase | "hello" → "Hello" |
| `${var^^}` | Converts entire string to uppercase | "hello" → "HELLO" |
| `${var,}` | Converts first character to lowercase | "HELLO" → "hELLO" |
| `${var,,}` | Converts entire string to lowercase | "HELLO" → "hello" |

**Important Note:** These Bash-specific features will not work with `sh <filename>` as `sh` executes scripts in POSIX shell mode, not Bash. You must change permissions and execute as `./<file>`.

### Convert String to Uppercase

**Purpose:** Transform a string to all uppercase letters.

**Key Concepts:**
- Using `${str^^}` for uppercase conversion

### Convert String to Lowercase

**Purpose:** Transform a string to all lowercase letters.

**Key Concepts:**
- Using `${str,,}` for lowercase conversion

### Reverse a String

**Purpose:** Reverse the order of characters in a string.

**Key Concepts:**
- The `rev` command
- Piping output: `echo "$str" | rev`

### Check if Two Strings are Equal

**Purpose:** Compare two strings for equality.

**Key Concepts:**
- Using `[[ "$str1" == "$str2" ]]` for string comparison
- Double brackets `[[ ]]` are Bash-specific (not available in `/bin/sh`)

### Extract a Substring

**Purpose:** Extract a portion of a string based on position and length.

**Key Concepts:**
- Substring expansion: `${str:position:length}`
- Position is 0-based

## 4. /bin/sh vs /bin/bash

### Key Differences

| Feature | /bin/sh | /bin/bash |
|---------|---------|-----------|
| Name | Bourne Shell (or POSIX shell) | Bourne Again Shell |
| Speed | Slightly faster (lighter) | Slightly slower (more features) |
| Portability | Very portable (exists on all UNIX systems) | Common but not guaranteed everywhere |
| Features | Basic, POSIX-compliant | Rich: arrays, functions, string ops, brace expansion, `[[ ]]`, `==`, etc. |
| Use case | Simple, portable scripts | Complex, interactive, feature-rich scripts |

### Example 1 - Bash-specific Feature

**Bash version:**
```bash
#!/bin/bash
name="vilas"
echo "Uppercase: ${name^^}"
```
**Output:** `Uppercase: VILAS`

**If changed to `#!/bin/sh`:**
**Output:** `example.sh: 3: Bad substitution`

**Why it failed:** `/bin/sh` doesn't understand the `${var^^}` syntax (Bash-only feature).

### Example 2 - Arrays

**Bash version:**
```bash
#!/bin/bash
colors=("red" "green" "blue")
echo "First color: ${colors[0]}"
echo "All colors: ${colors[@]}"
```
**Output:**
```
First color: red
All colors: red green blue
```

**If run with `/bin/sh`:** `syntax error: "(" unexpected`

**Why it failed:** `/bin/sh` doesn't support arrays.

### Example 3 - Conditional Expressions

**Bash version:**
```bash
#!/bin/bash
str="devops"
if [[ $str == devops ]]; then
    echo "Match"
fi
```
Works fine - `[[ ... ]]` is a Bash keyword.

**In `/bin/sh`:** `[: not found`

**Why it failed:** `/bin/sh` only supports single brackets `[ ... ]`.

### Example 4 - Command Substitution and Arithmetic

Both `/bin/sh` and `/bin/bash` support:
```bash
#!/bin/sh
echo $((3 + 4))
```
Works fine - because arithmetic expansion `$((...))` is POSIX-compliant.

### Practical Guidelines

| Situation | Which to use | Why |
|-----------|--------------|-----|
| Simple, portable scripts (init, cron, Docker entrypoint) | `/bin/sh` | Works across all Unix/Linux systems, lightweight |
| Scripts using arrays, regex, string manipulation, or color output | `/bin/bash` | Full Bash features available |
| Scripts meant for automation in modern Linux distros | `/bin/bash` | Bash is default on most systems |
| Minimalist or embedded systems (like Alpine) | `/bin/sh` (linked to ash) | Lightweight, minimal dependencies |

## 5. User Management Scripts

### Creating a User Without Standards

A basic script that creates a user and group without proper error handling or validation:

```bash
#!/bin/bash
USERNAME="$1"
GROUPNAME="$2"
groupadd "$GROUPNAME"
useradd -m -s /bin/bash -g "$GROUPNAME" "$USERNAME"
echo "echo \"Welcome, $USERNAME!!\"" >> /home/$USERNAME/.bashrc
echo "Setup complete! When '$USERNAME' logs in, they'll see a welcome message."
```

**Issues with this approach:**
- No error checking
- No validation of arguments
- No check if user/group already exists
- No root privilege check
- No proper error messages

### Creating a User with Standards

A production-ready script with proper error handling, validation, and best practices:

**Key Features:**
- Exit on error: `set -e`
- Root privilege check
- Argument validation
- Check if user/group already exists
- Proper error messages
- Optional password setting
- User information display

**Best Practices:**
- Use `getent` to check if user/group exists
- Provide clear usage instructions
- Handle edge cases
- Use descriptive variable names
- Add comments for clarity

## 6. Project Setup Scripts

### Utility Library Pattern

Creating reusable functions in a separate utility file that can be sourced by other scripts.

**Key Concepts:**
- Function definition: `function_name() { ... }`
- Local variables: `local variable_name`
- Function arguments: `$1`, `$2`, etc.
- Sourcing scripts: `source "$(dirname "$0")/utils.sh"`
- Command substitution for timestamps: `$(date +%Y%m%d-%H%M%S)`
- Safe directory creation: `mkdir -p`

### Assignment: Timestamped Directory Creation

**Objective:** Create a reusable utility script and a main script that automate project setup by creating uniquely named directories with timestamps.

**Components:**
1. **Utility Library (`utils.sh`):** Contains reusable functions
2. **Main Script (`setup_project.sh`):** Uses the utility functions

**Key Learning Points:**
- Writing reusable bash functions
- Importing functions across scripts using `source`
- Dynamically creating directories with unique timestamps
- Using arguments and command substitution for flexibility

## 7. Access Control Lists (ACLs)

### What are ACLs?

ACLs (Access Control Lists) allow you to define fine-grained permissions for multiple users or groups on the same file or directory - something not possible with basic UNIX permissions.

**Basic UNIX Permissions Limitations:**
- One owner
- One group
- Everyone else (others)

**With ACLs, you can:**
- Assign specific permissions to multiple users
- Assign specific permissions to multiple groups
- Example: "User john can read this file, mary can write it, and devgroup can execute it."

### Checking if ACLs are Enabled

Most modern filesystems (ext4, xfs, btrfs) support ACLs by default.

**To confirm:**
```bash
mount | grep acl
```

If you see `acl` in the mount options, it's enabled.

**If not, remount with ACL support:**
```bash
sudo mount -o remount,acl /home
```

**Or add acl to `/etc/fstab` for persistence:**
```
UUID=xxxx /home ext4 defaults,acl 0 2
```

### Viewing ACLs

**Command:** `getfacl filename`

**Example output:**
```
# file: project.txt
# owner: root
# group: root
user::rw-
user:john:r--
group::r--
mask::r--
other::---
```

This shows normal owner/group permissions plus extra ACL entries.

### Setting ACLs

**Use `setfacl` to assign ACL entries.**

**Give a user read access:**
```bash
setfacl -m u:john:r-- project.txt
```

**Give a group write access:**
```bash
setfacl -m g:developers:rw- project.txt
```

**Verify:**
```bash
getfacl project.txt
```

### Removing ACL Entries

**Remove one entry:**
```bash
setfacl -x u:john project.txt
```

**Remove all ACLs:**
```bash
setfacl -b project.txt
```

### Setting ACLs on Directories (Recursive)

**Example:**
```bash
setfacl -R -m u:john:rwX /var/www/
```

- `-R` → recursive
- `X` → execute permission only on directories (smart mode)

### Default ACLs

Default ACLs apply to new files/directories created inside a directory.

**Example:**
```bash
setfacl -d -m u:john:rwX /var/www/
```

Now any new file in `/var/www/` will automatically give John read/write access.

**Check:**
```bash
getfacl /var/www/
```

### Understanding the "mask" Field

When multiple ACL entries exist, Linux uses the mask to define the maximum allowed permissions for all users/groups other than the owner.

**Modify mask:**
```bash
setfacl -m m::r-- file.txt
```

Even if an ACL entry grants `rw`, if the mask is `r--`, the user effectively gets read-only access.

### Integrating ACLs with Scripts

**Example: Give a team shared access automatically:**

```bash
#!/bin/bash
SHARE_DIR="/data/team"
USER_LIST="alice bob charlie"

for user in $USER_LIST; do
    setfacl -m u:$user:rwx $SHARE_DIR
done
```

**Make it executable:**
```bash
chmod +x set_team_acl.sh
```

## Summary

Shell scripting is essential for DevOps automation. Key concepts covered:

- **Shebang and script execution:** Understanding different shell interpreters
- **Basic operations:** File checks, arithmetic, system information
- **String manipulation:** Case conversion, substring extraction, comparison
- **Shell differences:** `/bin/sh` vs `/bin/bash` and when to use each
- **Best practices:** Error handling, validation, reusable functions
- **Advanced topics:** ACLs for fine-grained permissions

Mastering these concepts enables automation of repetitive tasks, system administration, and DevOps workflows.
