#!/bin/bash
#  _____                    _       _             
# |_   _|__ _ __ ___  _ __ | | __ _| |_ ___  ___  
#   | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \/ __| 
#   | |  __/ | | | | | |_) | | (_| | ||  __/\__ \ 
#   |_|\___|_| |_| |_| .__/|_|\__,_|\__\___||___/ 
#                    |_|                          
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# Select text file
selected=$(ls -1 ~/private/templates | rofi -dmenu -p "Select the template")


if [ "$selected" ]; then
    # Add content to clipboard
    xclip -sel clip ~/private/templates/$selected
fi
