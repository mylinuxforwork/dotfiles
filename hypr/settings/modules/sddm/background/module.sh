#!/bin/bash
_getHeader "$name" "$author"

if gum confirm "Do you want to update the SDDM background with the current wallpaper?" ;then
    if [ ! -d /etc/sddm.conf.d/ ]; then
        sudo mkdir /etc/sddm.conf.d
        echo "Folder /etc/sddm.conf.d created."
    fi

    sudo cp ~/dotfiles/sddm/sddm.conf /etc/sddm.conf.d/
    echo "File /etc/sddm.conf.d/sddm.conf updated."

    sudo cp ~/.cache/current_wallpaper.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/
    echo "Current wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"

    sudo cp ~/dotfiles/sddm/theme.conf /usr/share/sddm/themes/sugar-candy/
    echo "File theme.conf updated in /usr/share/sddm/themes/sugar-candy/"

    echo ""
    echo "SDDM background successfully updated!"
    sleep 2
fi
_goBack
