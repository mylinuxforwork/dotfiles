#!/bin/bash
figlet -f smslant "Enable SDDM"
if [ -f /etc/systemd/system/display-manager.service ]; then
    echo ":: Display Manager is already enabled."
else
    if gum confirm "Do you want to enable SDDM as your display manager?" ;then
        sudo systemctl enable sddm.service
        echo ":: Display manager SDDM has been enabled." 
        echo ":: Please reboot your system!"
    fi
fi
sleep 3
