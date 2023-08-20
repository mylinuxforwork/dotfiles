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

# option1="Selected window (delay 3 sec)"
option2="Selected area"
option3="Fullscreen (delay 3 sec)"

# options="$option1\n$option2\n$option3"
options="$option2\n$option3"

choice=$(echo -e "$options" | rofi -dmenu -i -no-show-icons -l 4 -width 30 -p "Take Screenshot")

case $choice in
    $option1)
        scrot $DIR$NAME -d 3 -e 'xclip -selection clipboard -t image/png -i $f' -c -z -u
        notify-send "Screenshot created" "Mode: Selected window"
    ;;
    $option2)
        grim -g "$(slurp)" $(xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
        notify-send "Screenshot created" "Mode: Selected area"
    ;;
    $option3)
        sleep 3
        grim $(xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
        notify-send "Screenshot created" "Mode: Fullscreen"
    ;;
esac
