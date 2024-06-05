#!/bin/bash
#   ____                                          _      
#  / ___| __ _ _ __ ___   ___ _ __ ___   ___   __| | ___ 
# | |  _ / _` | '_ ` _ \ / _ \ '_ ` _ \ / _ \ / _` |/ _ \
# | |_| | (_| | | | | | |  __/ | | | | | (_) | (_| |  __/
#  \____|\__,_|_| |_| |_|\___|_| |_| |_|\___/ \__,_|\___|
#

if [ -f ~/.cache/gamemode ] ;then
    hyprctl keyword animations:enabled true
    hyprctl keyword decoration:blur:enabled true
    rm ~/.cache/gamemode
    notify-send "Gamemode deactivated" "Animations and blur enabled"
else
    hyprctl keyword animations:enabled false
    hyprctl keyword decoration:blur:enabled false
    touch ~/.cache/gamemode
    notify-send "Gamemode activated" "Animations and blur disabled"
fi
