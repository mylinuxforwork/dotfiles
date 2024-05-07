#!/bin/bash
clear

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|    

EOF
echo "for ML4W Hyprland Settings App"
echo
echo -e "${NONE}"
echo "This script will download the ML4W Dotfiles and start the installation."
echo
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
            echo
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Change into your Downloads directory
cd ~/Downloads

# Remove existing folder
if [ -d ~/Downloads/dotfiles ] ;then
    rm -rf ~/Downloads/dotfiles
fi

# Clone the packages
git clone --depth 1 https://gitlab.com/stephan-raabe/dotfiles.git

# Change into the folder
cd ml4w-hyprland-settings

# Start the script
./install.sh
