#!/bin/bash
#    ____         __       ____               __     __
#   /  _/__  ___ / /____ _/ / / __ _____  ___/ /__ _/ /____ ___
#  _/ // _ \(_-</ __/ _ `/ / / / // / _ \/ _  / _ `/ __/ -_|_-<
# /___/_//_/___/\__/\_,_/_/_/  \_,_/ .__/\_,_/\_,_/\__/\__/___/
#                                 /_/
#

# Check if command exists
_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

_isInstalled() {
    package="$1"
    case $install_platform in
        arch)
            check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "${package} ")"
            ;;
        fedora)
            check="$(dnf repoquery --quiet --installed ""${package}*"")"
            ;;
        *) ;;
    esac

    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

sleep 1
clear
figlet -f smslant "Updates"
echo

if gum confirm "DO YOU WANT TO START THE UPDATE NOW?"; then
    echo
    echo ":: Update started..."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Update canceled."
    exit
fi

# ----------------------------------------------------- 
# Install update
# ----------------------------------------------------- 

# Arch
if [[ $(_checkCommandExists "pacman") == 0 ]]; then
    aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
    $aur_helper

# Fedora
elif [[ $(_checkCommandExists "dnf") == 0 ]]; then
    sudo dnf upgrade
else
    echo ":: ERROR - Platform not supported"
    echo "Press [ENTER] to close."
    read
fi
echo

# Flatpak
echo ":: Searching for Flatpak updates..."
flatpak update
echo

# Reload Waybar
pkill -RTMIN+1 waybar

# Finishing
echo ":: Update complete! Press [ENTER] to close."
read
