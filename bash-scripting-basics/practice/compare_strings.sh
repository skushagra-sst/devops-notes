#!/bin/bash
# Check if Two Strings are Equal
# Note: This uses [[ ]] which is Bash-specific
read -p "Enter first string: " str1
read -p "Enter second string: " str2
if [[ "$str1" == "$str2" ]]; then
    echo "Strings are equal."
else
    echo "Strings are not equal."
fi
