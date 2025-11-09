#!/bin/bash
# Lab Exercise 1 - Basic Commands
# This script demonstrates basic Linux commands

echo "=== Lab Exercise 1: Basic Commands ==="

# a. Create a directory named starting_point
echo "Creating directory 'starting_point'..."
mkdir -p starting_point

# b. Navigate inside it
echo "Navigating to starting_point..."
cd starting_point

# c. Create a file called secret_lair.txt
echo "Creating file 'secret_lair.txt'..."
touch secret_lair.txt

# d. Display the absolute path of your current location
echo "Current absolute path:"
pwd

# e. View the history of commands executed
echo ""
echo "Recent command history:"
history | tail -10

echo ""
echo "Exercise 1 completed!"
