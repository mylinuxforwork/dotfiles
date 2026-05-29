#!/usr/bin/env bash

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    exit
fi

COMMAND="$1"

# Run 'flatpak info', redirecting standard output and errors to /dev/null to keep it silent
if command -v "$COMMAND" &> /dev/null; then
    echo 0
else
    if [ -f "$HOME/.local/bin/$COMMAND" ]; then
        echo 0
    else
        echo 1
    fi
fi