#!/bin/bash
#  ____
# |  _ \ __ _  ___ _ __ ___   __ _ _ __
# | |_) / _` |/ __| '_ ` _ \ / _` | '_ \
# |  __/ (_| | (__| | | | | | (_| | | | |
# |_|   \__,_|\___|_| |_| |_|\__,_|_| |_|
#

sleep 1
clear
figlet -f smslant "pacman.conf"
echo
echo ":: This script will activate or deactivate additions for your pacman.conf."
echo
if grep -Fq "#ParallelDownloads" /etc/pacman.conf; then
    if gum confirm "Do you want to activate parallel downloads?"; then
        sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
    else
        echo ":: Activation of parallel downloads skipped."
    fi
else
    echo ":: Parallel downloads are already activated."
fi

if grep -Fxq "#Color" /etc/pacman.conf; then
    if gum confirm "Do you want to activate colors?"; then
        sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
    else
        echo ":: Activation of Color skipped."
    fi
else
    echo ":: Color is already activated."
fi

if grep -Fxq "#VerbosePkgLists" /etc/pacman.conf; then
    if gum confirm "Do you want to activate VerbosePkgLists?"; then
        sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
    else
        echo ":: Activation of VerbosePkgLists skipped."
    fi
else
    echo ":: VerbosePkgLists is already activated."
fi

if grep -Fxq "ILoveCandy" /etc/pacman.conf; then
    echo ":: ILoveCandy is already activated."
else
    if gum confirm "Do you want to activate ILoveCandy?"; then
        sudo sed -i '/^ParallelDownloads = .*/a ILoveCandy' /etc/pacman.conf
    else
        echo ":: Activation of ILoveCandy skipped."
    fi
fi
echo
echo "Press [ENTER] to close."
read
