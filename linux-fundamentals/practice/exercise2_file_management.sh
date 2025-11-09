#!/bin/bash
# Lab Exercise 2 - File Management
# This script demonstrates file management operations

echo "=== Lab Exercise 2: File Management ==="

# a. Check if delete_directory exists and remove it
if [ -d "delete_directory" ]; then
    echo "Removing delete_directory..."
    rm -rf delete_directory
    echo "delete_directory removed."
else
    echo "delete_directory does not exist."
fi

# b. Delete delete.txt if it exists
if [ -f "delete.txt" ]; then
    echo "Removing delete.txt..."
    rm delete.txt
    echo "delete.txt removed."
else
    echo "delete.txt does not exist."
fi

# c. Use find to locate all .txt files under /home/user
echo ""
echo "Finding all .txt files under /home/user:"
if [ -d "/home/user" ]; then
    find /home/user -name "*.txt" 2>/dev/null
else
    echo "Directory /home/user does not exist. Searching in current directory instead:"
    find . -name "*.txt" 2>/dev/null
fi

# d. Display disk usage of /var/log/
echo ""
echo "Disk usage of /var/log/:"
if [ -d "/var/log" ]; then
    du -sh /var/log/ 2>/dev/null || echo "Permission denied. Run with sudo for /var/log access."
else
    echo "/var/log directory not found."
fi

echo ""
echo "Exercise 2 completed!"
