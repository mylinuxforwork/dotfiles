#!/bin/bash
figlet -f smslant "Disable SDDM"
if [ -f /etc/systemd/system/display-manager.service ]; then
    if gum confirm "Do you want to disable the current display manager?" ;then
        sudo rm /etc/systemd/system/display-manager.service
        echo ":: Current display manager removed." 
        echo ":: Please reboot your system."
    fi
else
    echo ":: No Display Manager enabled."
fi
sleep 3
