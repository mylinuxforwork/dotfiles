#!/usr/bin/env bash

# link dotfiles
if [ -f custom/link-dotfiles.sh ]; then
    ./custom/link-dotfiles.sh
else
    ./link-dotfiles.sh
fi

# Set up SDDM
if [ -f custom/sddm-setup.sh ]; then
    ./custom/sddm-setup.sh
else
    ./sddm-setup.sh
fi

# Create empty wireguard config if not exists
sudo touch /etc/wireguard/laptop.conf