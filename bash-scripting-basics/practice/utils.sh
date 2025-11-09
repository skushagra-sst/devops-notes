#!/bin/bash
# utils.sh — Utility functions for project setup

# Function to create a timestamped directory
create_timestamped_dir() {
    local project_name="$1"
    
    # Check if project name is provided
    if [ -z "$project_name" ]; then
        echo "Error: Project name not provided."
        return 1
    fi
    
    # Generate timestamp (format: YYYYMMDD-HHMMSS)
    local timestamp
    timestamp=$(date +%Y%m%d-%H%M%S)
    
    # Construct directory path under /tmp
    local dir_path="/tmp/${project_name}-${timestamp}"
    
    # Create the directory
    mkdir -p "$dir_path"
    
    # Print the full path of the created directory
    echo "Directory created: $dir_path"
}
