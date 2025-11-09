#!/bin/bash
# setup_project.sh — Main script to set up a new project

# Source the utility script (located in the same directory)
source "$(dirname "$0")/utils.sh"

# Call the utility function with project name
create_timestamped_dir "my-new-app"
