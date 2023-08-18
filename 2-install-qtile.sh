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

packagesPacman=("qtile" "polybar");

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";

# ------------------------------------------------------
# Install qtile configuration
# ------------------------------------------------------
echo ""
echo "-> Install Qtile configuration"
while true; do
    read -p "Do you want to install/replace the Qtile configuration? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -d ~/.config/qtile/ ]; then
                rm -r ~/.config/qtile/
            fi
    		_installSymLink ~/.config/qtile ~/dotfiles/qtile/ ~/.config
        break;;
        [Nn]* ) 
            echo "Installation/Replacement of Qtile configuration skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
_installSymLink ~/.config/polybar ~/dotfiles/polybar/ ~/.config

if [ -f ~/.xinitrc ]; then
    rm ~/.xinitrc
fi
ln -s ~/dotfiles/qtile/.xinitrc ~/.xinitrc

echo "DONE!"
