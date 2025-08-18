#!/usr/bin/env bash
SIDEPAD_ACTIVE=$(cat "$HOME/.config/ml4w/settings/sidepad-active")
echo ":: Current sidepad: $SIDEPAD_ACTIVE"

source $HOME/.config/sidepad/pads/$SIDEPAD_ACTIVE

echo ":: Current sidepad app: $SIDEPAD_APP"
echo ":: Current sidepad class: $SIDEPAD_CLASS"

pad=$(ls $HOME/.config/sidepad/pads | rofi -dmenu -replace -i -config ~/.config/rofi/config-compact.rasi -no-show-icons -width 30 -p "Sidepads")
if [ ! -z $pad ]; then
    echo ":: New sidepad: $pad"

    eval "$HOME/.config/sidepad/scripts/sidepad.sh --class '$SIDEPAD_CLASS' --kill"

    echo "$pad" > "$HOME/.config/ml4w/settings/sidepad-active"
    SIDEPAD_ACTIVE=$(cat "$HOME/.config/ml4w/settings/sidepad-active")

    source $HOME/.config/sidepad/pads/$pad
    eval "$HOME/.config/sidepad/scripts/sidepad.sh --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
    echo ":: Sidepad switched"
fi