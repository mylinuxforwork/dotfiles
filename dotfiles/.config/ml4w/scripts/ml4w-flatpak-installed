#!/usr/bin/env bash

# Check if a Flatpak ID was passed as an argument
if [ -z "$1" ]; then
    exit
fi

FLATPAK_ID="$1"

# Run 'flatpak info', redirecting standard output and errors to /dev/null to keep it silent
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    echo 0
else
    echo 1
fi