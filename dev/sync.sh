#!/usr/bin/env bash

# Get script folder
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Script Initialization and Argument Handling ---

# Parse parameters
DRY_RUN_FLAG=""
RUN_ONCE=0
for arg in "$@"; do
    case "$arg" in
        -n|--dry-run)
            DRY_RUN_FLAG="-n"
            echo ":: DRY RUN MODE ACTIVE"
            ;;
        -r|--run)
            RUN_ONCE=1
            echo ":: RUN ONCE MODE ACTIVE"
            ;;
        -h|--help)
            echo "Usage: ${BASH_SOURCE[0]##*/} [-n|--dry-run] [-r|--run]"
            echo "  -n, --dry-run  Show what would be synced without changing anything"
            echo "  -r, --run      Run the sync once and exit (no listener)"
            exit 0
            ;;
        *)
            echo "Unknown parameter: $arg"
            exit 1
            ;;
    esac
done

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
    SOURCE_DIR=$(echo "$project_source" | envsubst)
else
    SOURCE_DIR=$(echo "$project_source/$project_subfolder" | envsubst)
fi
TARGET_DIR="$HOME/.mydotfiles/$project_id"
EVENTS="modify,create,delete,move"
EXCLUDE_FILE="$SCRIPT_DIR/protected"

echo ":: Source: $SOURCE_DIR"
echo ":: Target: $TARGET_DIR"
echo

# --- Sync ---

run_sync() {
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
    fi
}

# --- Single Run ---

if [ "$RUN_ONCE" -eq 1 ]; then
    echo ":: Running single sync for $project_name"
    run_sync
    echo
    echo ":: Sync successful."
    exit 0
fi

# --- Daemon Loop ---

echo ":: Starting Folder Sync Daemon for $project_name"

# Daemon will only run if NOT in dry-run mode, but the sync logic is tested
while true; do
    echo ":: Waiting for changes in $SOURCE_DIR..."

    # Wait for file system events
    inotifywait -r -e "$EVENTS" --quiet "$SOURCE_DIR"

    # Debounce period
    sleep 1

    echo ":: Change detected! Running sync now..."

    run_sync

    if [ -n "$DRY_RUN_FLAG" ]; then
        echo ":: You can exit the script with CTRL+C"
    fi
    echo
    echo ":: Sync successful. Returning to monitor mode."
done

exit 0