#!/bin/bash
#  _____      _       _               _____             __
# |  __ \    (_)     | |             / ____|           / _|
# | |__) | __ _ _ __ | |_ ___ _ __  | |     ___  _ __ | |_
# |  ___/ '__| | '_ \| __/ _ \ '__| | |    / _ \| '_ \|  _|
# | |   | |  | | | | | ||  __/ |    | |___| (_) | | | | |
# |_|   |_|  |_|_| |_|\__\___|_|     \_____\___/|_| |_|_|
#
# By @krystalsavage

sleep 1
clear
figlet -f smslant "Printers"

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if gum confirm "DO YOU WANT TO START TO INSTALL PRINTER SYSTEM NOW?"; then
    echo
    echo ":: Install started."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Install canceled."
    exit
fi

if [[ $(_isInstalledYay "timeshift") == "0" ]]; then
    if gum confirm "DO YOU WANT TO CREATE A SNAPSHOT?"; then
        echo
        c=$(gum input --placeholder "Enter a comment for the snapshot...")
        sudo timeshift --create --comments "$c"
        sudo timeshift --list
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo ":: DONE. Snapshot $c created!"
        echo
    elif [ $? -eq 130 ]; then
        echo ":: Snapshot canceled."
        exit 130
    else
        echo ":: Snapshot canceled."
    fi
    echo
fi

yay -S cups cups-pdf cups-filters nss-mdns system-config-printer foomatic-db footmatic-db-engine foomatic-db-nonfree doomatic-db-nonfree-ppds foomatic-db-ppds cups-browsed libusb ipp-usb xdg-utils colord logrotate

notify-send "Installing printer system complete"
echo
echo ":: Installing printer system complete"
sleep 2

if [ -f ~/.config/ml4w/settings/printer-drivers.sh ]; then
    if gum confirm "DO YOU WANT TO INSTALL PRINTER DRIVERS NOW?"; then
        echo
        echo ":: Install started."
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo
        echo ":: Install cancelled."
        exit
    fi
fi
