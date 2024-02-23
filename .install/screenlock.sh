#!/bin/bash
echo -e "${GREEN}"
figlet "Screen lock"
echo -e "${NONE}"
if [[ $(_isInstalledYay "hypridle-git") == 1 ]] || [[ $(_isInstalledYay "hyprlock-git") == 1 ]]; then
    echo "You can install hypridle and hyprlock lock your screen automatically."
    if gum confirm "Do you want to install hypridle and hyprlock?" ;then
        yay --noconfirm -S hypridle-git hyprlock-git
    fi
else
    echo ":: hypridle and hyprlock are already installed."
fi
echo