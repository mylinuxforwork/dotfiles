#!/bin/bash
#  ___           _        _ _   _   _           _       _             
# |_ _|_ __  ___| |_ __ _| | | | | | |_ __   __| | __ _| |_ ___  ___  
#  | || '_ \/ __| __/ _` | | | | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
#  | || | | \__ \ || (_| | | | | |_| | |_) | (_| | (_| | ||  __/\__ \ 
# |___|_| |_|___/\__\__,_|_|_|  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#                                    |_|                              
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 
# Required: yay trizen timeshift btrfs-grub
# ----------------------------------------------------- 

sleep 1
source ~/dotfiles/scripts/library.sh
clear

echo "-----------------------------------------------------"
echo "Check for updates"
echo "-----------------------------------------------------"
echo ""

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
    updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 0 ]; then

    echo "-> Pacman:"
    checkupdates
    echo ""
    echo "-> AUR"
    trizen -Su --aur
    echo ""
    echo "-> $updates updates available."
    echo ""
else
    echo "-> NO updates available"
    exit
fi

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

while true; do
    read -p "DO YOU WANT TO START THE UPDATE NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Update process started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [[ $(_isInstalledYay "Timeshift") == 1 ]];
then

    echo ""
    echo "-----------------------------------------------------"
    echo "Create a snapshot"
    echo "-----------------------------------------------------"
    echo ""
    read -p "Enter a comment for the snapshot: " c
    sudo timeshift --create --comments "$c"
    sudo timeshift --list
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo "DONE. Snapshot $c created!"
    echo ""

fi

echo "-----------------------------------------------------"
echo "Start update"
echo "-----------------------------------------------------"
echo ""

yay
