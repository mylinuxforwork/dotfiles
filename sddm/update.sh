#!/bin/bash
#  _   _           _       _                 _     _            
# | | | |_ __   __| | __ _| |_ ___   ___  __| | __| |_ __ ___   
# | | | | '_ \ / _` |/ _` | __/ _ \ / __|/ _` |/ _` | '_ ` _ \  
# | |_| | |_) | (_| | (_| | ||  __/ \__ \ (_| | (_| | | | | | | 
#  \___/| .__/ \__,_|\__,_|\__\___| |___/\__,_|\__,_|_| |_| |_| 
#       |_|                                                     
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

clear
echo "Update the background wallpaper of sddm to the current wallpaper."
echo ""
if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir /etc/sddm.conf.d
    echo "Folder /etc/sddm.conf.d created."
fi

sudo cp sddm.conf /etc/sddm.conf.d/
echo "File /etc/sddm.conf.d/sddm.conf updated."

sudo cp ~/.cache/current_wallpaper.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/
echo "Current wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"

sudo cp theme.conf /usr/share/sddm/themes/sugar-candy/
echo "File theme.conf updated in /usr/share/sddm/themes/sugar-candy/"

echo ""
echo "DONE! Please logout to test sddm."
