#!/bin/bash
#   ____                                          _
#  / ___| __ _ _ __ ___   ___ _ __ ___   ___   __| | ___
# | |  _ / _` | '_ ` _ \ / _ \ '_ ` _ \ / _ \ / _` |/ _ \
# | |_| | (_| | | | | | |  __/ | | | | | (_) | (_| |  __/
#  \____|\__,_|_| |_| |_|\___|_| |_| |_|\___/ \__,_|\___|
#
#
_loadGameMode() {
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
}

if [ -f $HOME/.config/ml4w/settings/gamemode-enabled ]; then
    _loadGameMode
    notify-send "Gamemode activated" "Animations and blur disabled"
fi