    #!/bin/bash

    # Open rofi to select the Hyprshade filter for toggle
    options="$(ls ~/dotfiles/hypr/effects/wallpaper/)\noff"
    
    # Open rofi
    choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/dotfiles/rofi/config-themes.rasi -i -no-show-icons -l 5 -width 30 -p "Hyprshade") 
    if [ ! -z $choice ] ;then
        echo "$choice" > ~/dotfiles/.settings/wallpaper-effect.sh
        dunstify "Changing Wallpaper Effect to " "$choice"
        ~/dotfiles/hypr/scripts/wallpaper.sh init
    fi