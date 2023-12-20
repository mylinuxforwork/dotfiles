#!/bin/bash
#  _                             _ _       _                
# | |__   __ _ _ __ _____      _(_) |_ ___| |__   ___ _ __  
# | '_ \ / _` | '__/ __\ \ /\ / / | __/ __| '_ \ / _ \ '__| 
# | |_) | (_| | |  \__ \\ V  V /| | || (__| | | |  __/ |    
# |_.__/ \__,_|_|  |___/ \_/\_/ |_|\__\___|_| |_|\___|_|    
#                                                           
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Load status bar information
# ----------------------------------------------------- 
bar=$(cat ~/.cache/.qtile_bar_x11.sh)

# ----------------------------------------------------- 
# Switch status bar information
# ----------------------------------------------------- 
if [ $bar == "qtile" ]; then
    echo "Change to Polybar"
    echo "polybar" > ~/.cache/.qtile_bar_x11.sh
    notify-send "Status Bar is changing..." "to Polybar"
else
    echo "Change to Qtile Bar"
    echo "qtile" > ~/.cache/.qtile_bar_x11.sh
    notify-send "Status Bar is changing..." "to Qtile Status Bar"
fi

# ----------------------------------------------------- 
# Load status bar
# ----------------------------------------------------- 
~/dotfiles/qtile/scripts/x11/loadbar.sh