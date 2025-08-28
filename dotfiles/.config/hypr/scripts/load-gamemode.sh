#!/usr/bin/env bash
#                                      __   
#   ___ ____ ___ _  ___ __ _  ___  ___/ /__ 
#  / _ `/ _ `/  ' \/ -_)  ' \/ _ \/ _  / -_)
#  \_, /\_,_/_/_/_/\__/_/_/_/\___/\_,_/\__/ 
# /___/                                     
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