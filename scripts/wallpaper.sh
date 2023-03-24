#!/bin/bash
# __        __    _ _                              
# \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __  
#  \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#   \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#    \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                    |_|         |_|               
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# Select wallpaper
selected=$(ls -1 ~/wallpaper | rofi -dmenu -p "Select the wallpaper")

# Update wallpaper with pywal
wal -q -i ~/wallpaper/$selected

# Wait for 1 sec
sleep 1

# Reload qtile to color bar
qtile cmd-obj -o cmd -f reload_config
