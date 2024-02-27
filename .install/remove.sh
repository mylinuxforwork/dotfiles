#!/bin/bash
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
if [[ $(_isInstalledYay "hyprlock-git") == 0 ]]; then
    yay --noconfirm -Rns hyprlock-git
    if [ -f /usr/lib/debug/usr/bin/hyprlock.debug ] ;then
        sudo rm /usr/lib/debug/usr/bin/hyprlock.debug
        echo ":: /usr/lib/debug/usr/bin/hyprlock.debug removed"
    fi
    echo ":: hyprlock-git uninstalled."
    echo ":: hyprlock can now be installed."
fi
echo