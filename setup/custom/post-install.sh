#!/usr/bin/env bash

# link dotfiles 
if [ -f custom/link-dotfiles.sh ]; then
    ./custom/link-dotfiles.sh
else
    ./link-dotfiles.sh
fi

# Enable SDDM
sudo systemctl enable sddm.service

# Set theme for SDDM
echo """[AutoLogin]
Session=hyprland

[Theme]
Current=sugar-candy
""" | sudo tee /etc/sddm.conf > /dev/null

# Create empty wireguard config if not exists
sudo touch /etc/wireguard/laptop.conf