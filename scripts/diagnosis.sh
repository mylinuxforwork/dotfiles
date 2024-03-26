#!/bin/bash
clear
sleep 0.5
figlet "Diagnosis"
echo
echo "This script will check if some core packages are available on your system."
echo

_commandExists() {
    package="$1";
    if ! type $package > /dev/null; then
        echo ":: ERROR: $package doesn't exists. Please install it."
    else
        echo ":: OK: $package found."
    fi
}

_folderExists() {
    folder="$1";
    if [ ! -d $folder ]; then
        echo ":: ERROR: $folder doesn't exists."
    else
        echo ":: OK: $folder found."
    fi
}

_commandExists "rofi"
_commandExists "dunst"
_commandExists "waybar"
_commandExists "swww"
_commandExists "wal"
_commandExists "gum"
_commandExists "wlogout"

echo
echo "Press return to close the window"
read