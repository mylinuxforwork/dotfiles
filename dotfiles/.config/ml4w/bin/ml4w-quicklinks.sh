#!/usr/bin/env bash

# ------------------------------------------
# CLI Quicklink Tool
# ------------------------------------------

# --- Configuration ---
CONFIG_FILE="$HOME/.quicklinks"

# 1. Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "--------------------------------------------------------"
    echo "⚠️  Quicklinks file not found!"
    echo "Please create: $CONFIG_FILE"
    echo "Format: Name | Description | Command or Script"
    echo "--------------------------------------------------------"
    
    # Optional: Ask to create a template
    read -p "Create a template file now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Example | This is a description | echo 'Hello World'" > "$CONFIG_FILE"
        echo "Template created. Please edit it and run the script again."
    fi
    exit 1
fi

# 2. UI Selection
SELECTED_LINE=$(cat "$CONFIG_FILE" | fzf \
    --style full \
    --height 40% --layout reverse --border \
    --prompt "🚀 Quick Access: " \
    --delimiter "|" --with-nth 1..3)

[ -z "$SELECTED_LINE" ] && exit 0

# 3. Extract Command
COMMAND=$(echo "$SELECTED_LINE" | cut -d'|' -f3- | sed 's/^[[:space:]]*//')

echo "🚀 Executing: $COMMAND"
eval "$COMMAND"
