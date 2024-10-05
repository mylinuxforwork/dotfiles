#!/bin/bash
# ------------------------------------------------------
# Compare installed version with used version
# ------------------------------------------------------

source ~/.config/ml4w/version/library.sh

if [ -f /usr/share/ml4w-hyprland/dotfiles/.config/ml4w/version/name ]; then
    installed_version=$(cat /usr/share/ml4w-hyprland/dotfiles/.config/ml4w/version/name)
    used_version=$(cat ~/.config/ml4w/version/name)
    if [[ $(testvercomp $used_version $installed_version "<") == "0" ]]; then
        notify-send "Please run ml4w-hyprland-setup" "Installed version is newer then the version you're currently using."
    fi
fi
