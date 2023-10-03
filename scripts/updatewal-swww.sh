#!/bin/bash
#  _____ _                           ______        ____        ____        __ 
# |_   _| |__   ___ _ __ ___   ___  / ___\ \      / /\ \      / /\ \      / / 
#   | | | '_ \ / _ \ '_ ` _ \ / _ \ \___ \\ \ /\ / /  \ \ /\ / /  \ \ /\ / /  
#   | | | | | |  __/ | | | | |  __/  ___) |\ V  V /    \ V  V /    \ V  V /   
#   |_| |_| |_|\___|_| |_| |_|\___| |____/  \_/\_/      \_/\_/      \_/\_/    
#                                                                             
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Select random wallpaper and create color scheme
# ----------------------------------------------------- 
wal -q -i ~/wallpaper/

# ----------------------------------------------------- 
# Load current pywal color scheme
# ----------------------------------------------------- 
source "$HOME/.cache/wal/colors.sh"

# ----------------------------------------------------- 
# Copy selected wallpaper into .cache folder
# ----------------------------------------------------- 
cp $wallpaper ~/.cache/current_wallpaper.jpg

# ----------------------------------------------------- 
# get wallpaper iamge name
# ----------------------------------------------------- 
newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")

# ----------------------------------------------------- 
# Set the new wallpaper
# ----------------------------------------------------- 
swww img $wallpaper \
    --transition-bezier .43,1.19,1,.4 \
    --transition-fps=60 \
    --transition-type="random" \
    --transition-duration=0.7 \
    --transition-pos "$( hyprctl cursorpos )"

~/dotfiles/waybar/launch.sh
sleep 1

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
notify-send "Colors and Wallpaper updated" "with image $newwall"

echo "DONE!"
