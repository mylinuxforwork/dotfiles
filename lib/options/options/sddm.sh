#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "SDDM Toggle"
echo -e "${NONE}"
if [ -f /etc/systemd/system/display-manager.service ]; then
    echo ":: A display manager is enabled."
    echo
    if gum confirm "Do you want to disable the current display manager?" ;then
        sudo rm /etc/systemd/system/display-manager.service
        echo ":: Current display manager disabled." 
        echo
        gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    fi
else
    echo ":: No display manager is enabled."
    echo
    if gum confirm "Do you want to enable SDDM as your display manager?" ;then
        if [[ ! $(_isInstalledAUR "sddm") == 0 ]]; then
            sudo pacman -S --noconfirm --needed sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg --ask 4
        fi
        sudo systemctl enable sddm.service
        echo ":: Display manager SDDM has been enabled." 
        echo
        gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    fi
fi
_selectCategory
