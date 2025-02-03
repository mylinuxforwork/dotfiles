#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "File Manager"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/filemanager.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "filemanager.sh"

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
    if [ $optionalSelect == "yazi" ]; then
        echo '$(cat ~/.config/ml4w/settings/terminal.sh) -e yazi' > "$HOME/.config/ml4w/settings/filemanager.sh"
    else
        echo "$optionalSelect" > "$HOME/.config/ml4w/settings/filemanager.sh"
    fi
    _selectCategory
fi
