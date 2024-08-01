#!/bin/bash
#     _         _         __        ______  
#    / \  _   _| |_ ___   \ \      / /  _ \ 
#   / _ \| | | | __/ _ \   \ \ /\ / /| |_) |
#  / ___ \ |_| | || (_) |   \ V  V / |  __/ 
# /_/   \_\__,_|\__\___/     \_/\_/  |_|    
#                                          

sec=$(cat ~/.config/ml4w/settings/wallpaper-automation.sh)
_setWallpaperRandomly() {
    waypaper --random
    echo ":: Next wallpaper in 60 seconds..."
    sleep $sec
    _setWallpaperRandomly
}

if [ ! -f ~/.cache/ml4w-wallpaper-automation ] ;then
    touch ~/.cache/ml4w-wallpaper-automation
    echo ":: Start wallpaper automation script"
    notify-send "Wallpaper automation process started" "Wallpaper will be changed every $sec seconds."
    _setWallpaperRandomly
else
    rm ~/.cache/ml4w-wallpaper-automation
    notify-send "Wallpaper automation process stopped."
    echo ":: Wallpaper automation script process $wp stopped"
    wp=$(pgrep -f wallpaper-automation.sh)
    kill -KILL $wp
fi