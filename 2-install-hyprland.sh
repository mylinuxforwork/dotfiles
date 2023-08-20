#!/bin/bash
#  _   _                  _                 _  
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | 
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | 
# |  _  | |_| | |_) | |  | | (_| | | | | (_| | 
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| 
#        |___/|_|                              
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 
# Install Script for Hyprland
# ------------------------------------------------------

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "  _   _                  _                 _  "
echo " | | | |_   _ _ __  _ __| | __ _ _ __   __| | "
echo " | |_| | | | | ,_ \| ,__| |/ _\ | ,_ \ / _, | "
echo " |  _  | |_| | |_) | |  | | (_| | | | | (_| | "
echo " |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| "
echo "        |___/|_|                              "
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
packagesPacman=("waybar" "grim" "slurp");

packagesYay=("hyprland-git" "swww" "swaylock");

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";

# ------------------------------------------------------
# Install qtile configuration
# ------------------------------------------------------
echo ""
echo "-> Install Hyprland configuration"
while true; do
    read -p "Do you want to install/replace the Hyprland configuration? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -d ~/.config/hypr/ ]; then
                rm -r ~/.config/hypr/
            fi
    		_installSymLink ~/.config/hypr ~/dotfiles/hypr/ ~/.config
        break;;
        [Nn]* ) 
            echo "Installation/Replacement of Hyprland configuration skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
_installSymLink ~/.config/waybar ~/dotfiles/waybar/ ~/.config

swww init

echo "DONE!"
