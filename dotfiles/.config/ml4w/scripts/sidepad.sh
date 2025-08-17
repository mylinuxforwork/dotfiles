#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  / 
# /___/_/\_,_/\__/ .__/\_,_/\_,_/  
#               /_/                
#

# --- Configuration ---
WINDOW_CLASS="dotfiles-sidepad"
HIDDEN_LEFT_GAP=10
VISIBLE_LEFT_GAP=20
TARGET_WIDTH=500
TARGET_WIDTH_MAX=1000
TOP_GAP=70
BOTTOM_GAP=20

# --- Script Variables ---
HIDE_REQUESTED=0

# --- Help Function ---
show_help() {
    echo "Usage: $0 [options]"
    echo "Please make sure that you're using the class only once."
    echo "The window must be in floating mode."
    echo ""
    echo "Options:"
    echo "  --class <name>         Override the window class (Default: $WINDOW_CLASS)"
    echo "  --hidden-gap <px>      Override the hidden left gap (Default: $HIDDEN_LEFT_GAP)"
    echo "  --visible-gap <px>     Override the visible left gap (Default: $VISIBLE_LEFT_GAP)"
    echo "  --width <px>           Override the target width (Default: $TARGET_WIDTH)"
    echo "  --width-max <px>       Override the maximum target width (Default: $TARGET_WIDTH_MAX)"
    echo "  --top-gap <px>         Override the top gap (Default: $TOP_GAP)"
    echo "  --bottom-gap <px>      Override the bottom gap (Default: $BOTTOM_GAP)"
    echo "  --hide                 Force the window to the hidden state."
    echo "  -h, --help             Display this help and exit"
    exit 0
}

# --- Parse Command-line Options ---
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --class)
        WINDOW_CLASS="$2"
        shift; shift
        ;;
        --hidden-gap)
        HIDDEN_LEFT_GAP="$2"
        shift; shift
        ;;
        --visible-gap)
        VISIBLE_LEFT_GAP="$2"
        shift; shift
        ;;
        --width)
        TARGET_WIDTH="$2"
        shift; shift
        ;;
        --width-max)
        TARGET_WIDTH_MAX="$2"
        shift; shift
        ;;
        --top-gap)
        TOP_GAP="$2"
        shift; shift
        ;;
        --bottom-gap)
        BOTTOM_GAP="$2"
        shift; shift
        ;;
        --hide)
        HIDE_REQUESTED=1
        shift
        ;;
        --init)
        eval "$2" &
        HIDE_REQUESTED=1
        # Wait for the window to appear, with a timeout
        for i in {1..50}; do # ~2 seconds timeout
            if hyprctl clients -j | jq -e --arg class "$WINDOW_CLASS" '.[] | select(.class == $class)' > /dev/null; then
                break
            fi
            sleep 0.1
        done
        shift 2
        ;;
        -h|--help)
        show_help
        ;;
        *)
        # unknown option
        shift
        ;;
    esac
done

# --- Get Window and Monitor Info ---
WINDOW_INFO=$(hyprctl clients -j | jq --arg class "$WINDOW_CLASS" '.[] | select(.class == $class)')
MONITOR_INFO=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')

if [ -z "$WINDOW_INFO" ]; then
    echo "Error: Window with class '$WINDOW_CLASS' not found. Is the window open?"
    exit 1
fi

WINDOW_ADDRESS=$(echo "$WINDOW_INFO" | jq -r '.address')
WINDOW_WIDTH=$(echo "$WINDOW_INFO" | jq -r '.size[0]')
WINDOW_HEIGHT=$(echo "$WINDOW_INFO" | jq -r '.size[1]')
WINDOW_X=$(echo "$WINDOW_INFO" | jq -r '.at[0]')
WINDOW_Y=$(echo "$WINDOW_INFO" | jq -r '.at[1]')
MONITOR_HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.height')

# --- Main Logic ---

# Case 1: --hide flag is used, unconditionally hide the window.
if [[ "$HIDE_REQUESTED" -eq 1 ]]; then
    if (( WINDOW_X >= 0 )); then # Only act if it is not already hidden
        echo "--- Hiding window (--hide) ---"
        PIXELS_TO_MOVE_X=$(( (WINDOW_X * -1) - TARGET_WIDTH + HIDDEN_LEFT_GAP ))
        WIDTH_CHANGE=$(( TARGET_WIDTH - WINDOW_WIDTH ))
        PIXELS_TO_MOVE_Y=$(( TOP_GAP - WINDOW_Y ))
        TARGET_HEIGHT=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
        HEIGHT_CHANGE=$(( TARGET_HEIGHT - WINDOW_HEIGHT ))

        hyprctl --batch "dispatch resizewindowpixel $WIDTH_CHANGE $HEIGHT_CHANGE,address:$WINDOW_ADDRESS; dispatch movewindowpixel $PIXELS_TO_MOVE_X $PIXELS_TO_MOVE_Y,address:$WINDOW_ADDRESS"
        echo "Operation completed."
    else
        echo "Window is already hidden."
    fi
    exit 0
fi

# Case 2: Window is hidden, so show it.
if (( WINDOW_X < 0 )); then
    echo "--- Showing window ---"
    PIXELS_TO_MOVE_X=$(( TARGET_WIDTH - HIDDEN_LEFT_GAP + VISIBLE_LEFT_GAP ))
    WIDTH_CHANGE=$(( TARGET_WIDTH - WINDOW_WIDTH ))
    PIXELS_TO_MOVE_Y=$(( TOP_GAP - WINDOW_Y ))
    TARGET_HEIGHT=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    HEIGHT_CHANGE=$(( TARGET_HEIGHT - WINDOW_HEIGHT ))

    hyprctl --batch "dispatch resizewindowpixel $WIDTH_CHANGE $HEIGHT_CHANGE,address:$WINDOW_ADDRESS; dispatch movewindowpixel $PIXELS_TO_MOVE_X $PIXELS_TO_MOVE_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."

# Case 3: Window is visible, so toggle its width and correct its position.
else
    # Ensure vertical position and height are correct
    PIXELS_TO_MOVE_Y=$(( TOP_GAP - WINDOW_Y ))
    TARGET_HEIGHT=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    HEIGHT_CHANGE=$(( TARGET_HEIGHT - WINDOW_HEIGHT ))
    
    # Don't move horizontally
    PIXELS_TO_MOVE_X=0

    # Calculate width change
    if (( WINDOW_WIDTH == TARGET_WIDTH )); then
        echo "--- Expanding width to max ---"
        WIDTH_CHANGE=$(( TARGET_WIDTH_MAX - WINDOW_WIDTH ))
    else
        echo "--- Shrinking width to default ---"
        WIDTH_CHANGE=$(( TARGET_WIDTH - WINDOW_WIDTH ))
    fi

    hyprctl --batch "dispatch resizewindowpixel $WIDTH_CHANGE $HEIGHT_CHANGE,address:$WINDOW_ADDRESS; dispatch movewindowpixel $PIXELS_TO_MOVE_X $PIXELS_TO_MOVE_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."
fi