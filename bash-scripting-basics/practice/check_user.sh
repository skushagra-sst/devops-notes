#!/bin/bash
# Check User Login
read -p "Enter username to check: " user
if id "$user" &>/dev/null; then
    echo "User '$user' exists."
else
    echo "User '$user' not found."
fi
