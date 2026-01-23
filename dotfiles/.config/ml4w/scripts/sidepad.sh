#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  / 
# /___/_/\_,_/\__/ .__/\_,_/\_,_/  
#               /_/                
# Dispatcher

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/ml4w/settings/launcher)

# Configuration
SIDEPAD_PATH="$HOME/.config/sidepad/sidepad"
SIDEPAD_DATA="$HOME/.config/ml4w/settings/sidepad-active"
SIDEPAD_POS_FILE="$HOME/.config/ml4w/settings/sidepad-position"
SIDEPAD_PADS_FOLDER="$HOME/.config/sidepad/pads"
SIDEPAD_SELECT="$HOME/.config/sidepad/scripts/select.sh"

# Load active sidepad
SIDEPAD_OPTIONS="--width 900 --width-max 1200"

# Load active sidepad with error handling
if [ ! -f "$SIDEPAD_DATA" ]; then
    echo "Error: Sidepad data file not found at $SIDEPAD_DATA"
    exit 1
fi
SIDEPAD_ACTIVE=$(cat "$SIDEPAD_DATA")

# Load position
if [ -f "$SIDEPAD_POS_FILE" ]; then
    SIDEPAD_POS=$(cat "$SIDEPAD_POS_FILE")
else
    SIDEPAD_POS="left"
fi

source "$SIDEPAD_PADS_FOLDER/$SIDEPAD_ACTIVE"

echo ":: Current sidepad: $SIDEPAD_ACTIVE"
echo ":: Current sidepad app: $SIDEPAD_APP"
echo ":: Current sidepad class: $SIDEPAD_CLASS"
echo ":: Current sidepad position: $SIDEPAD_POS"

# Check if sidepad window exists
is_sidepad_running() {
    hyprctl clients -j | jq -e --arg class "$SIDEPAD_CLASS" '.[] | select(.class == $class)' > /dev/null
    return $?
}

# Check if sidepad is visible (works for both left and right positions)
is_sidepad_visible() {
    local window_info=$(hyprctl clients -j | jq --arg class "$SIDEPAD_CLASS" '.[] | select(.class == $class)')
    
    if [ -z "$window_info" ]; then
        return 1  # Window doesn't exist
    fi
    
    local window_x=$(echo "$window_info" | jq -r '.at[0]')
    local window_width=$(echo "$window_info" | jq -r '.size[0]')
    local monitor_info=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
    local monitor_x=$(echo "$monitor_info" | jq -r '.x')
    local monitor_width=$(echo "$monitor_info" | jq -r '.width')
    
    if [ -z "$window_x" ] || [ "$window_x" == "null" ]; then
        return 1
    fi
    
    # Check visibility based on position
    if [[ "$SIDEPAD_POS" == "right" ]]; then
        # For right position: visible if right edge is on screen
        if (( window_x <= monitor_x + monitor_width - window_width )); then
            return 0  # visible
        fi
    else
        # For left position: visible if left edge is on screen
        if (( window_x >= monitor_x )); then
            return 0  # visible
        fi
    fi
    
    return 1  # hidden
}

# Select new sidepad with rofi
select_sidepad() {
    # Open rofi
    if [ "$launcher" == "walker" ]; then
        pad=$(ls $SIDEPAD_PADS_FOLDER | $HOME/.config/walker/launch.sh -d -n -N -H --maxheight 400 -p "Sidepads")
    else
        pad=$(ls $SIDEPAD_PADS_FOLDER | rofi -dmenu -replace -i -config ~/.config/rofi/config-compact.rasi -no-show-icons -width 30 -p "Sidepads")
    fi

    # Set new sidepad
    if [ ! -z $pad ]; then
        echo ":: New sidepad: $pad"

        # Kill existing sidepad
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --kill"

        # Write pad into active data file
        echo "$pad" > "$SIDEPAD_DATA"
        SIDEPAD_ACTIVE=$(cat "$SIDEPAD_DATA")

        # Init sidepad
        source "$SIDEPAD_PADS_FOLDER/$pad"
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
        echo ":: Sidepad switched"
    fi
}

# Switch sidepad position (left <-> right)
switch_side() {
    local new_pos
    if [[ "$SIDEPAD_POS" == "left" ]]; then
        new_pos="right"
    else
        new_pos="left"
    fi
    
    echo ":: Switching sidepad from $SIDEPAD_POS to $new_pos"
    
    # If sidepad is running, smoothly move it to the other side
    if is_sidepad_running; then
        eval "$SIDEPAD_PATH --position '$new_pos' --class '$SIDEPAD_CLASS' $SIDEPAD_OPTIONS"
    fi
    
    # Update position file for future sessions
    echo "$new_pos" > "$SIDEPAD_POS_FILE"
    
    echo ":: Sidepad switched to $new_pos"
}

# Dispatch parameters
if [[ "$1" == "--init" ]]; then
    eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
    
elif [[ "$1" == "--hide" ]]; then
    eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --hide"
    
elif [[ "$1" == "--toggle" ]]; then
    if ! is_sidepad_running; then
        echo ":: Sidepad not running, initializing..."
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
    elif is_sidepad_visible; then
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --hide"
    else
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' $SIDEPAD_OPTIONS"
    fi
    
elif [[ "$1" == "--test" ]]; then
    eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --test"
    
elif [[ "$1" == "--kill" ]]; then
    eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --kill"
    
elif [[ "$1" == "--switch-side" ]]; then
    switch_side
    
elif [[ "$1" == "--select" ]]; then
    select_sidepad
    
else
    # Default action: init if not running, otherwise show
    if ! is_sidepad_running; then
        echo ":: Sidepad not running, initializing..."
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
    else
        eval "$SIDEPAD_PATH --position '$SIDEPAD_POS' --class '$SIDEPAD_CLASS' $SIDEPAD_OPTIONS"
    fi
fi