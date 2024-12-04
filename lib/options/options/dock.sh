#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Dock"
echo -e "${NONE}"
if [[ ! $(_isInstalled "nwg-dock-hyprland") == 0 ]]; then
    if gum confirm "Do you want to install nwg-dock-hyprland?" ;then
        _installPackage "nwg-dock-hyprland"
    fi
else
    gum spin --spinner dot --title "nwg-dock-hyprland is already installed" -- sleep 3
fi
_selectCategory