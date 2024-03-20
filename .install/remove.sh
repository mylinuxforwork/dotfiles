#!/bin/bash

# Remove Rofi Calc
if [[ $(_isInstalledPacman "rofi-calc") == 0 ]]; then
    sudo pacman --noconfirm -Rns rofi-calc
    echo ":: rofi-calc removed"
    echo
fi

# Remove Rofi
if [[ $(_isInstalledPacman "rofi") == 0 ]]; then
    sudo pacman --noconfirm -Rns rofi
    echo ":: rofi removed"
    echo
fi

# Remove Swayidle
if [[ $(_isInstalledPacman "swayidle") == 0 ]]; then
    sudo pacman --noconfirm -Rns swayidle
    echo ":: swayidle removed"
    echo
fi

# Remove Swaylock
if [[ $(_isInstalledYay "swaylock-effects-git") == 0 ]]; then
    yay --noconfirm -Rns swaylock-effects-git
    echo ":: swaylock removed"
    echo
fi

# Remove hypridle-bin
if [[ $(_isInstalledYay "hypridle-git") == 0 ]]; then
    yay --noconfirm -Rns hypridle-git
    if [ -f /usr/lib/debug/usr/bin/hypridle.debug ] ;then
        sudo rm /usr/lib/debug/usr/bin/hypridle.debug
        echo ":: /usr/lib/debug/usr/bin/hypridle.debug removed"
    fi
    echo ":: hypridle-git uninstalled."
    echo ":: hypridle can now be installed."
    echo 
fi

# Remove hypridle-bin
if [[ $(_isInstalledYay "hyprlock-git") == 0 ]]; then
    yay --noconfirm -Rns hyprlock-git
    if [ -f /usr/lib/debug/usr/bin/hyprlock.debug ] ;then
        sudo rm /usr/lib/debug/usr/bin/hyprlock.debug
        echo ":: /usr/lib/debug/usr/bin/hyprlock.debug removed"
    fi
    echo ":: hyprlock-git uninstalled."
    echo ":: hyprlock can now be installed."
    echo
fi