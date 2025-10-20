#!/usr/bin/env bash

# Get script folder
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Script Initialization and Argument Handling ---

# Check if the first parameter is -n or --dry-run
if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
    DRY_RUN_FLAG="-n"
    echo ":: DRY RUN MODE ACTIVE"
else
    DRY_RUN_FLAG=""
fi

# Find the first file ending with .dotinst in the current directory
FULL_PATH=$(find $SCRIPT_DIR -maxdepth 1 -type f -name "*.dotinst" -print -quit)
if [ -n "$FULL_PATH" ]; then
    FIRST_FILE="${FULL_PATH##*/}" # Strips path prefix, leaving only the filename
    echo ":: .dotinst: $FIRST_FILE"
else
    echo "No files with the .dotinst ending were found."
    exit 1
fi

# --- Configuration Reading (Assumes 'jq' is available) ---

# Read .dotinst file
project_name=$(jq -r '.name' "$SCRIPT_DIR/$FIRST_FILE")
project_id=$(jq -r '.id' "$SCRIPT_DIR/$FIRST_FILE")
project_source=$(jq -r '.source' "$SCRIPT_DIR/$FIRST_FILE")
project_subfolder=$(jq -r '.subfolder' "$SCRIPT_DIR/$FIRST_FILE")

# Configuration
if [ -z "$project_subfolder" ]; then
    SOURCE_DIR="$HOME/$project_source"
else
    SOURCE_DIR="$HOME/$project_source/$project_subfolder"
fi
TARGET_DIR="$HOME/.mydotfiles/$project_id"
EVENTS="modify,create,delete,move"
EXCLUDE_FILE="$SCRIPT_DIR/protected.txt"

echo ":: Source: $SOURCE_DIR"
echo ":: Target: $TARGET_DIR"
echo
echo ":: Starting Folder Sync Daemon for $project_name"

# --- Daemon Loop ---

# Daemon will only run if NOT in dry-run mode, but the sync logic is tested
while true; do
    echo ":: Waiting for changes in $SOURCE_DIR..."
    
    # Wait for file system events
    inotifywait -r -e "$EVENTS" --quiet "$SOURCE_DIR"
    
    # Debounce period
    sleep 1 
    
    echo ":: Change detected! Running sync now..."
    
    # Construct the base rsync command flags
    RSYNC_CMD="rsync -azv --delete --exclude=config.dotinst $DRY_RUN_FLAG"

    # Add the exclude-from option if the file exists
    if [ -f "$EXCLUDE_FILE" ]; then
        echo ":: Protected file list ($EXCLUDE_FILE) detected and will be used."
        RSYNC_CMD="$RSYNC_CMD --exclude-from=\"$EXCLUDE_FILE\""
    fi

    if [ -n "$DRY_RUN_FLAG" ]; then
        echo :: rsync command: $RSYNC_CMD "$SOURCE_DIR/" "$TARGET_DIR"
        echo
    fi

    # Execute the final rsync command
    eval $RSYNC_CMD "$SOURCE_DIR/" "$TARGET_DIR"

    if [ -n "$DRY_RUN_FLAG" ]; then
        echo
        echo ":: DRY RUN COMPLETE. No changes were made to $TARGET_DIR."
        echo ":: You can exit the script with CTRL+C"
    fi
    echo
    echo ":: Sync successful. Returning to monitor mode."
done

exit 0