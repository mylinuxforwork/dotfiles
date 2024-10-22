#!/bin/bash
clear
if [ -f /etc/systemd/system/display-manager.service ]; then
    echo -e "${GREEN}"
    figlet -f smslant "Disable SDDM"
    echo -e "${NONE}"
    echo ":: A display manager is enabled."
    echo
    if gum confirm "Do you want to disable the current display manager?" ;then
        sudo rm /etc/systemd/system/display-manager.service
        echo ":: Current display manager disabled." 
        gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    fi
else
    echo -e "${GREEN}"
    figlet -f smslant "Enable SDDM"
    echo -e "${NONE}"
    echo ":: No display manager is enabled."
    echo
    if gum confirm "Do you want to enable SDDM as your display manager?" ;then
        if [[ ! $(_isInstalledAUR "sddm") == 0 ]]; then
            $aur_helper -S sddm
        fi
        sudo systemctl enable sddm.service
        echo ":: Display manager SDDM has been enabled." 
        gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    fi

fi
_selectCategory
