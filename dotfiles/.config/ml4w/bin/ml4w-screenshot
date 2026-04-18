#!/usr/bin/env bash

# ------------------------------------------
# CLI Screenshot Tool
# ------------------------------------------

# --- Configuration ---

# Defaults
SAVE_DIR="$HOME/Pictures"
SAVE_FILENAME="screenshot_$(date +%d%m%Y_%H%M%S).jpg"

# Load Settings
if [ -f ~/.config/ml4w/settings/screenshot-folder ]; then
    SAVE_DIR=$(cat ~/.config/ml4w/settings/screenshot-folder)
fi
if [ -f ~/.config/ml4w/settings/screenshot-filename ]; then
    SAVE_FILENAME=$(cat ~/.config/ml4w/settings/screenshot-filename)
fi

# Generate path
eval screenshot_folder="$SAVE_DIR"
eval filename="$SAVE_FILENAME"
path="$screenshot_folder/$filename"

# Create Screenshot folder
mkdir -p "$SAVE_DIR"

# Handle the screenshot
take_screenshot() {
    local mode=$1
    local delay=$2
    # Apply delay
    if [ "$delay" -gt 0 ]; then
        echo "⏱️ Waiting $delay seconds..."
        sleep "$delay"
    fi

    echo "📸 Capturing $mode..."

    case $mode in
        "fullscreen")
            grim "$path"
            ;;
        "area")
            # slurp allows UI selection
            GEOM=$(slurp)
            [ -z "$GEOM" ] && exit 0 # Handle ESC/Cancel
            grim -g "$GEOM" "$path"
            ;;
        "window")
            # Hyprland specific geometry
            GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
            grim -g "$GEOM" "$path"
            ;;
    esac

    # Finalize and Notify
    if [ -f "$path" ]; then
        wl-copy < "$path"
        echo "---------------------------------------"
        echo "✅ Success!"
        echo "📂 Saved: $path"
        echo "📋 Copied to clipboard."
        echo "---------------------------------------"
        sleep 1
    else
        echo "❌ Error: Screenshot failed."
    fi
}

# --- Main Logic ---

# 1. Fast Mode (Check for arguments)
if [ "$#" -ge 1 ]; then
    take_screenshot "$1" "${2:-0}"
    exit 0
fi

# 2. Interactive Mode (fzf)

# Selection 1: Choose Mode
MODE_CHOICE=$(echo -e "area\nwindow\nfullscreen" | fzf \
    --style full \
    --height 15% \
    --layout reverse \
    --border \
    --prompt "🎯 Select Screenshot Mode: " \
    --header "ESC to cancel")

[ -z "$MODE_CHOICE" ] && exit 0

# Selection 2: Choose Delay
DELAY_CHOICE=$(echo -e "0s\n2s\n5s\n10s" | fzf \
    --style full \
    --height 15% \
    --layout reverse \
    --border \
    --prompt "⏳ Set Delay: " \
    --header "Time before capture")

[ -z "$DELAY_CHOICE" ] && exit 0

# Strip the 's' from the delay choice (e.g., "5s" -> "5")
CLEAN_DELAY=$(echo "$DELAY_CHOICE" | sed 's/s//')

take_screenshot "$MODE_CHOICE" "$CLEAN_DELAY"