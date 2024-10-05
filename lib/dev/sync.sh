#!/bin/bash
# Execute the script with ./sync version e.g., ./sync 2.5.2

if [ ! -z "$1" ]; then
    if [ -d ~/.ml4w-hyprland/"$1" ]; then
        echo "Folder exists. Start rsync now ..."
        rsync -avhp -I --exclude-from="$HOME"/.ml4w-hyprland/"$1"/lib/dev/excludes.txt ~/.ml4w-hyprland/dotfiles/share/dotfiles/ ~/dotfiles
    else
        echo "Folder ~/.ml4w-hyprland/$1 not found."
    fi

    sudo cp ~/.ml4w-hyprland/dotfiles/share/apps/com.ml4w.welcome /usr/bin
    sudo cp ~/.ml4w-hyprland/dotfiles/share/apps/com.ml4w.dotfilessettings /usr/bin
    sudo cp ~/.ml4w-hyprland/dotfiles/share/apps/com.ml4w.hyprland.settings /usr/bin

else
    echo "No folder specified. Please use ./sync folder"
fi
