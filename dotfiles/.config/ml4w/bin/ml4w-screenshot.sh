#!/bin/bash

# --- Configuration ---
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# --- Function to handle the screenshot ---
take_screenshot() {
    local mode=$1
    local delay=$2
    local filename="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
    local path="$SAVE_DIR/$filename"

    # Apply delay if user selected one
    if [ "$delay" -gt 0 ]; then
        echo "Waiting $delay seconds..."
        sleep "$delay"
    fi

    echo "Capturing $mode..."

    case $mode in
        "fullscreen")
            grim "$path"
            ;;
        "area")
            # slurp lets you draw a box on screen
            grim -g "$(slurp)" "$path"
            ;;
        "window")
            # Hyprland-specific logic to get active window dimensions
            GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
            grim -g "$GEOM" "$path"
            ;;
    esac

    # Finalize
    if [ -f "$path" ]; then
        wl-copy < "$path"
        echo "---------------------------------------"
        echo "✅ Success!"
        echo "📂 Saved: $path"
        echo "📋 Copied to clipboard."
        echo "---------------------------------------"
        sleep 2
    else
        echo "❌ Error: Screenshot failed."
    fi
}

# --- Main Logic ---

# Check if arguments were passed (Fast Mode)
# Example: ./screenshot.sh area 0
if [ "$#" -ge 1 ]; then
    take_screenshot "$1" "${2:-0}"
    exit 0
fi

clear
figlet -f smslant "Screenshot"
echo


# Interactive Mode (Gum UI)
MODE_CHOICE=$(gum choose --header "Select Mode" "fullscreen" "area" "window")
[ -z "$MODE_CHOICE" ] && exit 0

DELAY_CHOICE=$(gum choose --header "Set Delay (seconds)" "0" "2" "5" "10")
[ -z "$DELAY_CHOICE" ] && exit 0

take_screenshot "$MODE_CHOICE" "$DELAY_CHOICE"