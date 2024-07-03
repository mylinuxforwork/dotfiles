#!/bin/bash
#  ____                               _           _    
# / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_  
# \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __| 
#  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_  
# |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__| 
#                                                      
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

DIR="$HOME/Pictures/screenshots/"
NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

option2="Selected area"
option3="Fullscreen (delay 3 sec)"
option4="Current display (delay 3 sec)"

options="$option2\n$option3\n$option4"
current_hyprshade=""
choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/dotfiles/rofi/config-screenshot.rasi -i -no-show-icons -l 3 -width 30 -p "Take Screenshot")
if [ ! -z $(hyprshade current) ] ;then
    current_hyprshade=$(hyprshade current)
    echo ":: Switch hyprshade off"
    hyprshade off
fi

case $choice in
    $option2)
        grim -g "$(slurp)" "$DIR$NAME"
        echo $current_hyprshade
        if [ ! -z $current_hyprshade ] ;then
            hyprshade on $current_hyprshade
        fi
        xclip -selection clipboard -t image/png -i "$DIR$NAME"
        notify-send "Screenshot created and copied to clipboard" "Mode: Selected area"
        swappy -f "$DIR$NAME"
    ;;
    $option3)
        sleep 3
        grim "$DIR$NAME" 
        if [ ! -z $current_hyprshade ] ;then
            hyprshade on $current_hyprshade
        fi
        xclip -selection clipboard -t image/png -i "$DIR$NAME"
        notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
        swappy -f "$DIR$NAME"
    ;;
    $option4)
        sleep 3
        monitor="$(hyprctl monitors | awk '/Monitor/{monitor=$2} /focused: yes/{print monitor; exit}')"
        grim -o "$monitor" "$DIR$NAME"
        if [ ! -z $current_hyprshade ] ;then
            hyprshade on $current_hyprshade
        fi
        xclip -selection clipboard -t image/png -i "$DIR$NAME"
        notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
        swappy -f "$DIR$NAME"
    ;;
esac
