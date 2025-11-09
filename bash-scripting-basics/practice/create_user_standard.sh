#!/bin/bash
# ===============================================
# Script Name: create_user_standard.sh
# Description: Create a new Linux user and group,
# set home directory and shell.
# Usage: sudo ./create_user_standard.sh <username> <groupname>
# ===============================================

# Exit immediately if a command fails
set -e

# Check if script is run as root (user management needs root)
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Check for required arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <username> <groupname>"
    exit 1
fi

USERNAME="$1"
GROUPNAME="$2"

# Step 1: Create group (if not exists)
if getent group "$GROUPNAME" > /dev/null; then
    echo "Group '$GROUPNAME' already exists."
else
    echo "Creating group '$GROUPNAME'..."
    groupadd "$GROUPNAME"
    echo "Group '$GROUPNAME' created."
fi

# Step 2: Create user (if not exists)
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
else
    echo "Creating user '$USERNAME'..."
    useradd -m -s /bin/bash -g "$GROUPNAME" "$USERNAME"
    echo "User '$USERNAME' created with home directory /home/$USERNAME"
fi

# Step 3: (Optional) Add user to additional groups
# Example: Add to 'sudo' if needed
# usermod -aG sudo "$USERNAME"

# Step 4: Display user info
echo "-----------------------------------------"
echo "User Information:"
id "$USERNAME"
echo "-----------------------------------------"

# Step 5: Set password (optional prompt)
read -p "Do you want to set a password for $USERNAME? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    passwd "$USERNAME"
fi

echo "User setup completed successfully!"
