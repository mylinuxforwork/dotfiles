#!/bin/bash
figlet "Disable SDDM"
if [ -f /etc/systemd/system/display-manager.service ]; then
    if gum confirm "Do you want to disable the current display manager?" ;then
        sudo rm /etc/systemd/system/display-manager.service
        echo "Current display manager removed. Please reboot your system."
    fi
else
    echo "No display manager enabled."
fi
sleep 3
