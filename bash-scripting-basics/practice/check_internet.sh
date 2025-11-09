#!/bin/bash
# Check Internet Connectivity
if ping -c 1 8.8.8.8 &>/dev/null; then
    echo "Internet is working."
else
    echo "No internet connection."
fi
