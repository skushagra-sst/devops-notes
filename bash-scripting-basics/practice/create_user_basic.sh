#!/bin/bash
# Shell script to create a user without following standards
# This is a basic example - not recommended for production

USERNAME="$1"
GROUPNAME="$2"
groupadd "$GROUPNAME"
useradd -m -s /bin/bash -g "$GROUPNAME" "$USERNAME"
# Add welcome message to .bashrc
echo "echo \"Welcome, $USERNAME!!\"" >> /home/$USERNAME/.bashrc
echo "Setup complete! When '$USERNAME' logs in, they'll see a welcome message."
