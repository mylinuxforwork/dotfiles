#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Terminal"
echo -e "${NONE}"
source $packages_directory/options/terminal.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "terminal.sh"

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ] ;then
    _selectCategory
elif [ $optionalSelect == "CANCEL" ]; then
    _selectCategory
else
    if [[ ! $(_isInstalledAUR "$optionalSelect") == 0 ]]; then
        $aur_helper -S $optionalSelect
    fi
    echo "$optionalSelect" > "$HOME/.config/ml4w/settings/terminal.sh"
    _selectCategory
fi
