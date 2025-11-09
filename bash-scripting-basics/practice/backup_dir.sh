#!/bin/bash
# Backup a Directory
read -p "Enter source directory: " src
read -p "Enter backup directory: " dest
tar -czf "$dest/backup_$(date +%F).tar.gz" "$src"
echo "Backup completed successfully!"
