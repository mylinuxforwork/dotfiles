#!/bin/bash
#  ____              _                         _         
# | __ )  ___   ___ | | ___ __ ___   __ _ _ __| | _____  
# |  _ \ / _ \ / _ \| |/ / '_ ` _ \ / _` | '__| |/ / __| 
# | |_) | (_) | (_) |   <| | | | | | (_| | |  |   <\__ \ 
# |____/ \___/ \___/|_|\_\_| |_| |_|\__,_|_|  |_|\_\___/ 
#                                                        
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

selected=$(cat ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks | grep '"url":' | awk '{print $2}' | sed 's/"//g' | rofi -dmenu -p "Select a Brave Bookmark")

if [ "$selected" ]; then
    brave $selected
fi
