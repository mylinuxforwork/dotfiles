#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Email Client"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/email.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "email.sh"

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ] || [ "$optionalSelect" = "CANCEL" ]; then
    if [ -z "$options_argument" ]; then
        _selectCategory
    else
        exit
    fi
else
    if [[ ! $(_isInstalled "$optionalSelect") == 0 ]]; then
        _installPackage $optionalSelect
    fi
    echo "$optionalSelect" >"$HOME/.config/ml4w/settings/email.sh"
    _selectCategory
fi
