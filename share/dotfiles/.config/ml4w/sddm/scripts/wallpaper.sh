#!/bin/bash
#  _   _           _       _                 _     _            
# | | | |_ __   __| | __ _| |_ ___   ___  __| | __| |_ __ ___   
# | | | | '_ \ / _` |/ _` | __/ _ \ / __|/ _` |/ _` | '_ ` _ \  
# | |_| | |_) | (_| | (_| | ||  __/ \__ \ (_| | (_| | | | | | | 
#  \___/| .__/ \__,_|\__,_|\__\___| |___/\__,_|\__,_|_| |_| |_| 
#       |_|                                                     
#  
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 
cache_file="$HOME/.config/ml4w/cache/current_wallpaper"
sleep 1
clear
figlet -f smslant "Set Wallpaper"
echo
echo "Set the current wallpaper as SDDM wallpaper."
echo
if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir /etc/sddm.conf.d
    echo "Folder /etc/sddm.conf.d created."
fi

sudo cp $HOME/.config/ml4w/sddm/sddm.conf /etc/sddm.conf.d/
echo "File /etc/sddm.conf.d/sddm.conf updated."

current_wallpaper=$(cat "$cache_file")
extension="${current_wallpaper##*.}"

sudo cp $current_wallpaper /usr/share/sddm/themes/sugar-candy/Backgrounds/current_wallpaper.$extension
echo "Current wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"
new_wall=$(echo $current_wallpaper | sed "s|$HOME/wallpaper/||g")
sudo cp $HOME/.config/ml4w/sddm/theme.conf /usr/share/sddm/themes/sugar-candy/
sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.$extension"'/' /usr/share/sddm/themes/sugar-candy/theme.conf

echo "File theme.conf updated in /usr/share/sddm/themes/sugar-candy/"

echo "DONE! Please logout to test sddm."
sleep 3
