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
source $(dirname "$0")/scripts/library.sh
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
echo ""
echo "-> Install main packages"

packagesPacman=("qtile" "picom" "polybar");

# packagesYay=("brave-bin" "pfetch" "bibata-cursor-theme");
# pywal installation below 

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------

echo "-> Create symbolic link for startx"
_installSymLink ~/.config/picom ~/dotfiles/picom/ ~/.config
_installSymLink ~/.config/polybar ~/dotfiles/polybar/ ~/.config

rm ~/.xinitrc
ln -s ~/dotfiles/qtile/.xinitrc ~/.xinitrc

echo "DONE!"
