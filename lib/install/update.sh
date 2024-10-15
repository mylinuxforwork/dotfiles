#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Update"
echo -e "${NONE}"
echo
echo ":: Please choose your version:"
echo
dot_ver=$(gum choose "ml4w-hyprland" "ml4w-hyprland-git" "Cancel")
if [ ! -z $dot_ver ] ;then
    if [[ ! $dot_ver == "Cancel" ]] ;then
        aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
        $aur_helper --noconfirm -S "$dot_ver";
        ml4w-hyprland-setup
    fi
else
    exit
fi
