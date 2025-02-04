#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Pywalfox"
echo -e "${NONE}"
if [[ ! $(_isInstalled "python-pywalfox") == 0 ]]; then
    echo "In addition, you have to install the Firefox plugin"
    echo "https://addons.mozilla.org/en-US/firefox/addon/pywalfox/"
    echo
    if gum confirm "Do you want to install python-pywalfox?" ;then
        _installPackage "python-pywalfox"
    fi
else
    gum spin --spinner dot --title "Pywalfox is already installed" -- sleep 3
fi
if [ -z "$options_argument" ]; then
    _selectCategory
else
    exit
fi