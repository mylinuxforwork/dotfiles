#!/bin/bash
# __        ______    _____             _
# \ \      / /  _ \  | ____|_ __   __ _(_)_ __   ___
#  \ \ /\ / /| |_) | |  _| | '_ \ / _` | | '_ \ / _ \
#   \ V  V / |  __/  | |___| | | | (_| | | | | |  __/
#    \_/\_/  |_|     |_____|_| |_|\__, |_|_| |_|\___|
#                                 |___/
#

wallpaper_engine=$(cat $HOME/.config/ml4w/settings/wallpaper-engine.sh)
if [ "$wallpaper_engine" == "swww" ]; then
    # swww
    echo ":: Using swww"
    swww init
    swww-daemon --format xrgb
    sleep 0.5
    ~/.config/hypr/scripts/wallpaper.sh init
elif [ "$wallpaper_engine" == "hyprpaper" ]; then
    # hyprpaper
    echo ":: Using hyprpaper"
    sleep 0.5
    ~/.config/hypr/scripts/wallpaper.sh init
else
    echo ":: Wallpaper Engine disabled"
    ~/.config/hypr/scripts/wallpaper.sh init
fi
