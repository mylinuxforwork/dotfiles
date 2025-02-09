#!/bin/bash
dotfiles="$HOME/.ml4w-hyprland/dotfiles"

# share
sudo cp -r $dotfiles/share/. /usr/share/ml4w-hyprland
echo ":: share installed"

# lib
sudo cp -r $dotfiles/lib/. /usr/lib/ml4w-hyprland
echo ":: lib installed"

# bin
sudo cp $dotfiles/bin/ml4w-hyprland-setup /usr/bin/ml4w-hyprland-setup
echo ":: bin installed"
