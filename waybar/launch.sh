#!/bin/sh
#  ____  _             _    __        __          _                 
# / ___|| |_ __ _ _ __| |_  \ \      / /_ _ _   _| |__   __ _ _ __  
# \___ \| __/ _` | '__| __|  \ \ /\ / / _` | | | | '_ \ / _` | '__| 
#  ___) | || (_| | |  | |_    \ V  V / (_| | |_| | |_) | (_| | |    
# |____/ \__\__,_|_|   \__|    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    
#                                           |___/                   
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Quit running waybar instances
# ----------------------------------------------------- 
killall waybar

# ----------------------------------------------------- 
# Get current theme information
# ----------------------------------------------------- 
themestyle="/default/light"
if [ -f ~/.cache/.themestyle.sh ]; then
    themestyle=$(cat ~/.cache/.themestyle.sh)
else
    touch ~/.cache/.themestyle.sh
    echo "$themestyle" > ~/.cache/.themestyle.sh
fi
if [ ! -f ~/dotfiles/waybar/styles$themestyle/style.css ]; then
    themestyle="/default/light"
fi

# ----------------------------------------------------- 
# Loading the configuration based on the username
# ----------------------------------------------------- 
if [[ $USER = "raabe" ]]
then
    waybar -c ~/dotfiles/waybar/myconfig -s ~/dotfiles/waybar/styles$themestyle/style.css &
else
    waybar -s ~/dotfiles/waybar/styles$themestyle/style.css &
fi 
