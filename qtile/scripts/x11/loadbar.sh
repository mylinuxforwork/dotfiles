#!/bin/bash
#  _                 _ _                 
# | | ___   __ _  __| | |__   __ _ _ __  
# | |/ _ \ / _` |/ _` | '_ \ / _` | '__| 
# | | (_) | (_| | (_| | |_) | (_| | |    
# |_|\___/ \__,_|\__,_|_.__/ \__,_|_|    
#                                        
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Check if information about the bar exists in .cache
# If not create it
# ----------------------------------------------------- 
if [ ! -f ~/.cache/.qtile_bar_x11.sh ]; then
    touch ~/.cache/.qtile_bar_x11.sh
    echo "qtile" > ~/.cache/.qtile_bar_x11.sh
    echo ".qtile_bar_x11.sh created"
fi    

# ----------------------------------------------------- 
# Load status bar information
# ----------------------------------------------------- 
bar=$(cat ~/.cache/.qtile_bar_x11.sh)

# ----------------------------------------------------- 
# Load status bar based on loaded information
# ----------------------------------------------------- 
if [ $bar == "qtile" ]; then
    killall polybar
    sleep 0.2
    qtile cmd-obj -o cmd -f reload_config
else
    killall polybar
    sleep 0.2
    qtile cmd-obj -o cmd -f reload_config
    sleep 0.2
    source "$HOME/.cache/wal/colors.sh"
    ~/dotfiles/polybar/launch.sh &
    sleep 0.2
    qtile cmd-obj -o cmd -f reload_config
fi

