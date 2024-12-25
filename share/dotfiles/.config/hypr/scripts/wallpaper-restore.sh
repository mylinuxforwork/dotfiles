#!/bin/bash
#                _ _                              
# __      ____ _| | |_ __   __ _ _ __   ___ _ __  
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                   |_|         |_|               
#  
# ----------------------------------------------------- 
# Restore last wallpaper
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Set defaults
# ----------------------------------------------------- 

defaultwallpaper="$HOME/wallpaper/default.jpg"
cachefile="$HOME/.config/ml4w/cache/current_wallpaper"

# ----------------------------------------------------- 
# Get current wallpaper
# ----------------------------------------------------- 

if [ -f "$cachefile" ]; then
    sed -i "s|~|$HOME|g" "$cachefile"
    wallpaper=$(cat $cachefile)
    if [ -f $wallpaper ]; then
        echo ":: Wallpaper $wallpaper exists"
    else
        echo ":: Wallpaper $wallpaper does not exist. Using default."
        wallpaper=$defaultwallpaper
    fi
else
    echo ":: $cachefile does not exist. Using default wallpaper."
    wallpaper=$defaultwallpaper
fi

# ----------------------------------------------------- 
# Set wallpaper
# ----------------------------------------------------- 

echo ":: Setting wallpaper with source image $wallpaper"
waypaper --wallpaper "$wallpaper"
