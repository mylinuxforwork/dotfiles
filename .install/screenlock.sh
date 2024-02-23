#!/bin/bash
echo -e "${GREEN}"
figlet "Screen lock"
echo -e "${NONE}"
if [[ $(_isInstalledYay "hypridle-git") == 1 ]] || [[ $(_isInstalledYay "hyprlock-git") == 1 ]]; then
    echo "You can install hypridle and hyprlock to lock your screen automatically."
    echo "These are the new standard screen locking packages of the ML4W dotfiles."
    echo "Screenlocking will not work anymore if you keep swaylock."
    echo "The installation is highly recommended."
    if gum confirm "Do you want to install hypridle and hyprlock?" ;then

        # Install Hypridle and Hyprlock
        yay --noconfirm -S hypridle-git hyprlock-git

        # Remove Swayidle
        if [[ $(_isInstalledPacman "swayidle") == 0 ]]; then
            sudo pacman --noconfirm -Rns swayidle
        fi

        # Remove Swaylock
        if [[ $(_isInstalledYay "swaylock-effects-git") == 0 ]]; then
            yay --noconfirm -Rns swaylock-effects-git
        fi
        
    fi
else
    echo ":: hypridle and hyprlock are already installed."
fi
echo