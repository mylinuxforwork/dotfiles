#!/bin/bash
sec=$(cat ~/dotfiles/.settings/wallpaper-random.sh)
_setWallpaperRandomly() {
    waypaper --random
    echo ":: Next wallpaper in 60 seconds"
    sleep $sec
    _setWallpaperRandomly
}

if [ ! -f ~/.cache/ml4w-wallpaper-random ] ;then
    touch ~/.cache/ml4w-wallpaper-random
    echo ":: Start random wallpaper script"
    notify-send "Random wallpaper process started" "Wallpaper will be changed every $sec seconds."
    _setWallpaperRandomly
else
    rm ~/.cache/ml4w-wallpaper-random
    notify-send "Random Wallpaper process stopped."
    echo ":: Random wallpaper script process $wp stopped"
    wp=$(pgrep -f wallpaper-random.sh)
    kill -KILL $wp
fi