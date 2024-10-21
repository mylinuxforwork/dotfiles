#!/bin/bash
dotfiles="/home/raabe/.ml4w-hyprland/dotfiles"

# share
sudo cp -r $dotfiles/share/. /usr/share/ml4w-hyprland
echo ":: share installed"

# lib
sudo cp -r $dotfiles/lib/. /usr/lib/ml4w-hyprland
echo ":: lib installed"

# bin
sudo cp $dotfiles/bin/ml4w-hyprland-setup /usr/bin/ml4w-hyprland-setup
echo ":: bin installed"

# apps
sudo cp $dotfiles/share/apps/com.ml4w.welcome /usr/bin
sudo cp $dotfiles/share/apps/com.ml4w.dotfilessettings /usr/bin
sudo cp $dotfiles/share/apps/com.ml4w.hyprland.settings /usr/bin
echo ":: Apps installed"