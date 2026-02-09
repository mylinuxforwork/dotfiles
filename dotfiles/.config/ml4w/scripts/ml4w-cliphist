#!/usr/bin/env bash
#   ____ _ _       _     _     _
#  / ___| (_)_ __ | |__ (_)___| |_
# | |   | | | '_ \| '_ \| / __| __|
# | |___| | | |_) | | | | \__ \ |_
#  \____|_|_| .__/|_| |_|_|___/\__|
#           |_|
#

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/ml4w/settings/launcher)
if [ "$launcher" == "walker" ]; then
    $HOME/.config/walker/launch.sh -m clipboard -N -H
else
    case $1 in
        d)
            cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist delete
        ;;
        w)    
            cliphist wipe
        ;;
        *)
            cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist decode | wl-copy
        ;;
    esac
fi
