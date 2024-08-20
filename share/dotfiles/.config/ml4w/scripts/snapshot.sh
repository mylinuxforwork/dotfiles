#!/bin/bash
#  ____                        _           _    
# / ___| _ __   __ _ _ __  ___| |__   ___ | |_  
# \___ \| '_ \ / _` | '_ \/ __| '_ \ / _ \| __| 
#  ___) | | | | (_| | |_) \__ \ | | | (_) | |_  
# |____/|_| |_|\__,_| .__/|___/_| |_|\___/ \__| 
#                   |_|                         
#  
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 

sleep 1
clear
figlet "Snapshot"

_isInstalledYay() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

timeshift_installed=$(_isInstalledYay "timeshift")
grubbtrfs_installed=$(_isInstalledYay "grub-btrfs")

if [[ $timeshift_installed == "0" ]] ;then
    c=$(gum input --placeholder "Enter a comment for the snapshot...")
    sudo timeshift --create --comments "$c"
    sudo timeshift --list
    if [[ -d /boot/grub ]] ;then
        if [[ -d /boot/grub ]] && [[ $grubbtrfs_installed == "1" ]] ;then
            if gum confirm "DO YOU WANT TO INSTALL grub-btrfs now?" ;then
                yay -S grub-btrfs

            else
                exit
            fi
        fi
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    echo "DONE. Snapshot $c created!"
else
    echo "ERROR: Timeshift is not installed."
    if gum confirm "DO YOU WANT TO INSTALL Timeshift now?" ;then
        yay -S timeshift
        echo 
        echo ":: Timeshift has been installed. Please restart this script."
        if [[ -d /boot/grub ]] && [[ $grubbtrfs_installed == "1" ]] ;then
            echo ":: grub-btrfs is required to select a snapshot on grub bootloader."
            if gum confirm "DO YOU WANT TO INSTALL grub-btrfs now?" ;then
                yay -S grub-btrfs
            else
                exit
            fi
        fi
    fi
fi