#!/bin/bash
#  __  __ _    _  ___        __  _                           _               
# |  \/  | |  | || \ \      / / | |    __ _ _   _ _ __   ___| |__   ___ _ __ 
# | |\/| | |  | || |\ \ /\ / /  | |   / _` | | | | '_ \ / __| '_ \ / _ \ '__|
# | |  | | |__|__   _\ V  V /   | |__| (_| | |_| | | | | (__| | | |  __/ |   
# |_|  |_|_____| |_|  \_/\_/    |_____\__,_|\__,_|_| |_|\___|_| |_|\___|_|   
#                                                                            

option1="ML4W Dotfiles Settings"
option2="Hyprland Settings"
option3="Change Wallpaper"
option4="Change Waybar Theme"
option5="ML4W Welcome App"

options="$option1\n"
options="$options$option2\n"
options="$options$option3\n"
options="$options$option4\n$option5"

choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/dotfiles/rofi/config-ml4w-launcher.rasi -l 5) 

case $choice in
	$option1)
        $HOME/dotfiles/apps/ML4W_Dotfiles_Settings-x86_64.AppImage ;;
	$option2)
        $HOME/dotfiles/apps/ML4W_Hyprland_Settings-x86_64.AppImage ;;
	$option3)
        $HOME/dotfiles/hypr/scripts/wallpaper.sh select ;;
	$option4)
        $HOME/dotfiles/waybar/themeswitcher.sh ;;
	$option5)
        $HOME/dotfiles/apps/ML4W_Welcome-x86_64.AppImage ;;
esac