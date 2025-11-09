#!/bin/bash
# Extract a Substring
read -p "Enter a string: " str
read -p "Enter starting position: " pos
read -p "Enter length: " len
echo "Substring: ${str:$pos:$len}"
