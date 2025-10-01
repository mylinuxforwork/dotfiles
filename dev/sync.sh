#!/usr/bin/env bash

# Find the first file ending with .dotinst in the current directory
FULL_PATH=$(find . -maxdepth 1 -type f -name "*.dotinst" -print -quit)
if [ -n "$FULL_PATH" ]; then
    FIRST_FILE="${FULL_PATH##*/}" # Strips path prefix, leaving only the filename
    echo "Found .dotinst file: $FIRST_FILE"
else
    echo "No files with the .dotinst ending were found."
    exit
fi

# Read .dotinst file
project_name=$(jq -r '.name' $FIRST_FILE)
project_id=$(jq -r '.id' $FIRST_FILE)
project_source=$(jq -r '.source' $FIRST_FILE)
project_subfolder=$(jq -r '.subfolder' $FIRST_FILE)

# Configuration
if [ -z $project_subfolder ]; then
    SOURCE_DIR="$HOME/$project_source"
else
    SOURCE_DIR="$HOME/$project_source/$project_subfolder"
fi
TARGET_DIR="$HOME/.mydotfiles/$project_id"
EVENTS="modify,create,delete,move"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo
echo ":: Starting Folder Sync Daemon for $project_name"

# Daemon
while true; do
    echo "Waiting for changes in $SOURCE_DIR..."
    inotifywait -r -e "$EVENTS" "$SOURCE_DIR"
    sleep 2 
    echo "Change detected! Running sync..."
    rsync -azv --delete --exclude="config.dotinst" --exclude="keyboard.conf" --exclude="waypaper/" "$SOURCE_DIR/" "$TARGET_DIR"
    echo "Sync successful. Returning to monitor mode."
done
exit 0