#!/bin/bash
# Reverse a String
# Note: This uses 'rev' command which is Bash-specific
read -p "Enter a string: " str
rev_str=$(echo "$str" | rev)
echo "Reversed string: $rev_str"
