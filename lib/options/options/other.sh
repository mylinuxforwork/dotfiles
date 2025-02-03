#!/usr/bin/env bash
clear
echo -e "${GREEN}"
figlet -f smslant "More"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/other.sh
toInstall=""
selectedInstall=""

_checkPackages

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ]; then
    _selectCategory
elif [ $optionalSelect == "CANCEL" ]; then
    _selectCategory
else
    if [[ ! $(_isInstalled "$optionalSelect") == 0 ]]; then
        _installPackage $optionalSelect
    fi
    if [ $optionalSelect == "pinta" ]; then
        echo 'pinta' > "$HOME/.config/ml4w/settings/screenshot-editor.sh"
    fi
    if [ $optionalSelect == "smile" ]; then
        echo 'pinta' > "$HOME/.config/ml4w/emojipicker.sh"
    fi
    if [ $optionalSelect == "gnome-text-editor" ]; then
        echo 'gnome-text-editor' > "$HOME/.config/ml4w/editor.sh"
    fi
    if [ $optionalSelect == "gnome-calculator" ]; then
        echo 'gnome-calculator' > "$HOME/.config/ml4w/calculator.sh"
    fi
    _selectCategory
fi
