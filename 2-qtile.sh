#!/bin/bash
#   ___ _____ ___ _     _____        
#  / _ \_   _|_ _| |   | ____|  
# | | | || |  | || |   |  _|   
# | |_| || |  | || |___| |___  
#  \__\_\|_| |___|_____|_____| 
#                               
# by Stephan Raabe (2023)
# ------------------------------------------------------
# Install Script for Qtile
# yay must be installed
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
ln -s ~/dotfiles/qtile/.xinitrc ~/.xinitrc

echo "DONE!"
