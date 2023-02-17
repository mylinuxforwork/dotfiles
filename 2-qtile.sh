#!/bin/bash

# ------------------------------------------------------
# Install Script for Qtile
# yay must be installed
# Copy this script into the home directory and start.
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START QTILE INSTALLATION..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install main packages"
sudo pacman -S qtile

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
rm ~/.xinitrc
ln -s ~/dotfiles/.xinitrc ~/.xinitrc

echo "DONE!"
