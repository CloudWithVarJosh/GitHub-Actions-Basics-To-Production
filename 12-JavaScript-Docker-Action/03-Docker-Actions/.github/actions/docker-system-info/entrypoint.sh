#!/bin/sh

NAME="$1"

echo "========================================"
echo "GitHub Docker Action"
echo "========================================"

echo
echo "Hello ${NAME}!"
echo

echo "Container Information"
echo "----------------------------------------"
echo "OS Information"
cat /etc/os-release
echo
echo "Current User     : $(whoami)"
echo "Working Directory: $(pwd)"