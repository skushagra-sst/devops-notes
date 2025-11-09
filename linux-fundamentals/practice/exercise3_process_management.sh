#!/bin/bash
# Lab Exercise 3 - Process Management
# This script demonstrates process management operations

echo "=== Lab Exercise 3: Process Management ==="

# a. List all running processes
echo "Listing all running processes:"
ps aux | head -20
echo ""

# b. Identify the process ID of sshd
echo "Finding process ID of sshd:"
SSHD_PID=$(pgrep sshd | head -1)
if [ -n "$SSHD_PID" ]; then
    echo "sshd process ID: $SSHD_PID"
    ps -p $SSHD_PID -o pid,cmd
else
    echo "sshd process not found."
fi
echo ""

# c. Start a background job using sleep 60
echo "Starting background job: sleep 60"
sleep 60 &
SLEEP_PID=$!
echo "Background job started with PID: $SLEEP_PID"
echo ""

# d. Display background jobs
echo "Current background jobs:"
jobs
echo ""

# e. Bring it to foreground (commented out as it would block)
# echo "Bringing job to foreground..."
# fg %1

# Alternative: Kill the sleep process
echo "Killing the sleep process (PID: $SLEEP_PID)..."
kill $SLEEP_PID 2>/dev/null && echo "Process killed successfully." || echo "Process already finished or not found."

echo ""
echo "Exercise 3 completed!"
