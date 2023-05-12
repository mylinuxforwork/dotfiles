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
# ------------------------------------------------------

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
clear
echo "  ___ _____ ___ _     _____  "
echo " / _ \_   _|_ _| |   | ____| "     
echo "| | | || |  | || |   |  _|   "
echo "| |_| || |  | || |___| |___  "
echo " \__\_\|_| |___|_____|_____| "
echo "                             " 
echo "by Stephan Raabe (2023)"
echo "------------------------------------------------------"
echo ""

while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
sudo pacman -S --noconfirm qtile

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic link for startx"
rm ~/.xinitrc
ln -s ~/dotfiles/qtile/.xinitrc ~/.xinitrc

echo "DONE!"
