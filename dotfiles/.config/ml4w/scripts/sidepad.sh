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
SIDEPAD_PADS_FOLDER="$HOME/.config/sidepad/pads"
SIDEPAD_SELECT="$HOME/.config/sidepad/scripts/select.sh"

# Load active sidepad
SIDEPAD_OPTIONS=""
SIDEPAD_ACTIVE=$(cat "$SIDEPAD_DATA")
source $SIDEPAD_PADS_FOLDER/$(cat "$SIDEPAD_DATA")
source $SIDEPAD_PADS_FOLDER/$SIDEPAD_ACTIVE
echo ":: Current sidepad: $SIDEPAD_ACTIVE"
echo ":: Current sidepad app: $SIDEPAD_APP"
echo ":: Current sidepad class: $SIDEPAD_CLASS"

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
        eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --kill"

        # Write pad into active data file
        echo "$pad" > "$SIDEPAD_DATA"
        SIDEPAD_ACTIVE=$(cat "$SIDEPAD_DATA")

        # Init sidepad
        source $SIDEPAD_PADS_FOLDER/$pad
        eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
        echo ":: Sidepad switched"
    fi
}

# Dispatch parameters
if [[ "$1" == "--init" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
elif [[ "$1" == "--hide" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --hide"
elif [[ "$1" == "--test" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --test"
elif [[ "$1" == "--kill" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --kill"
elif [[ "$1" == "--select" ]]; then
    select_sidepad
else
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' $SIDEPAD_OPTIONS"
fi
