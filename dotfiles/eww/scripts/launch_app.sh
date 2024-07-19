#!/bin/bash
if [[ "$1" == "--welcome" ]]; then
    $HOME/dotfiles/apps/ML4W_Welcome-x86_64.AppImage &
elif [[ "$1" == "--dotfiles" ]]; then
    $HOME/dotfiles/apps/ML4W_Dotfiles_Settings-x86_64.AppImage &
elif [[ "$1" == "--hyprland" ]]; then
	$HOME/dotfiles/apps/ML4W_Hyprland_Settings-x86_64.AppImage &
else
    echo "ERROR: $1 not found"
fi

$HOME/dotfiles/eww/ml4w-sidebar/launch.sh &