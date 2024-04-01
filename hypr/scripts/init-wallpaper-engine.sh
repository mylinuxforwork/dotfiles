#!/bin/bash
wallpaper_engine=$(cat $HOME/dotfiles/.settings/wallpaper-engine.sh)
if [ "$wallpaper_engine" == "swww" ] ;then
    # swww
    echo ":: Using swww"
    swww init
    swww-daemon --format xrgb
    sleep 0.5
    ~/dotfiles/hypr/scripts/wallpaper.sh init
elif [ "$wallpaper_engine" == "hyprpaper" ] ;then    
    # hyprpaper
    echo ":: Using hyprpaper"
    sleep 0.5
    ~/dotfiles/hypr/scripts/wallpaper.sh init
else
    echo ":: Wallpaper Engine disabled"
    ~/dotfiles/hypr/scripts/wallpaper.sh init
fi

