#!/bin/bash
#   ____                                          _      
#  / ___| __ _ _ __ ___   ___ _ __ ___   ___   __| | ___ 
# | |  _ / _` | '_ ` _ \ / _ \ '_ ` _ \ / _ \ / _` |/ _ \
# | |_| | (_| | | | | | |  __/ | | | | | (_) | (_| |  __/
#  \____|\__,_|_| |_| |_|\___|_| |_| |_|\___/ \__,_|\___|
#
#

if [ -f ~/.cache/gamemode ] ;then
    hyprctl reload
    rm ~/.cache/gamemode
    notify-send "Gamemode deactivated" "Animations and blur enabled"
else
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
	touch ~/.cache/gamemode
    notify-send "Gamemode activated" "Animations and blur disabled"
fi
