#!/bin/bash

# --- Configuration ---
# 1. Image Search Directory (RESOLVE PATH FIRST)
# Use 'realpath' to ensure the path is fully resolved and absolute

# Defaults
SEARCH_PATH="$HOME/Pictures/Wallpapers"

# Load Settings
if [ -f ~/.config/ml4w/settings/wallpaper-folder ]; then
    SEARCH_PATH=$(cat ~/.config/ml4w/settings/wallpaper-folder)
fi
eval SEARCH_PATH="$SEARCH_PATH"
SEARCH_PATH="$(realpath "$SEARCH_PATH")" 

# --- 2. Find Images (Recursively) ---
# Added -maxdepth 5 to allow subfolders, and -type f for files only
LIST=$(find "$SEARCH_PATH" -maxdepth 5 -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.webp" -o \
    -iname "*.gif" \
\) 2>/dev/null)

# --- 3. UI Selection with fzf and Ueberzug Preview ---
if [ -z "$LIST" ]; then
    # Final check for the directory existence itself
    if [ ! -d "$SEARCH_PATH" ]; then
        echo "❌ Error: Directory '$SEARCH_PATH' not found. Please create it."
        echo ":: You can define your own Wallpaper folder in ~/.config/ml4w/settings/wallpaper-folder"
    else
        echo "❌ Error: No images (jpg/png/webp/gif) found in $SEARCH_PATH."
        echo ":: You can define your own Wallpaper folder in ~/.config/ml4w/settings/wallpaper-folder"
    fi
    exit 1
fi

SELECTED=$(echo "$LIST" | fzf \
    --style full \
    --height 70% \
    --layout reverse \
    --border \
    --prompt "🖼️ Select Image: " \
    --header "ENTER to set wallpaper with waypaper" \
    --preview-window right:50%:wrap
    )
# --- 4. Action ---
if [ -n "$SELECTED" ]; then
    printf '{"action": "remove", "identifier": "fzf_preview"}\n' > /tmp/fzf-ueberzug.pipe 2>/dev/null
    
    # Execute waypaper command
    # Source 1.1 confirms --wallpaper is the correct CLI option
    waypaper --wallpaper "$SELECTED" & >/dev/null 2>&1
    exit 0
fi