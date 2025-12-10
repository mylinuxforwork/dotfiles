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

# Copy sugar-candy theme
if [ -d custom/sugar-candy ]; then
    sudo cp -r custom/sugar-candy /usr/share/sddm/themes/
else
  sudo cp -r sugar-candy /usr/share/sddm/themes/
fi


# Create empty wireguard config if not exists
sudo touch /etc/wireguard/laptop.conf