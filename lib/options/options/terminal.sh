#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Terminal"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/terminal.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "terminal.sh"

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ]; then
    _selectCategory
elif [ $optionalSelect == "CANCEL" ]; then
    _selectCategory
else
    if [[ ! $(_isInstalled "$optionalSelect") == 0 ]]; then
        _installPackage $optionalSelect
    fi
    echo "$optionalSelect" >"$HOME/.config/ml4w/settings/terminal.sh"
    _selectCategory
fi
