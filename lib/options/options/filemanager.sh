#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "File Manager"
echo -e "${NONE}"
source $packages_directory/options/filemanager.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "filemanager.sh"

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ] ;then
    _selectCategory
elif [ $optionalSelect == "CANCEL" ]; then
    _selectCategory
else
    if [[ ! $(_isInstalledAUR "$optionalSelect") == 0 ]]; then
        $aur_helper -S $optionalSelect
    fi
    if [ $optionalSelect == "yazi" ]; then
        echo '$(cat ~/.config/ml4w/settings/terminal.sh) -e yazi' > "$HOME/.config/ml4w/settings/filemanager.sh"
    else
        echo "$optionalSelect" > "$HOME/.config/ml4w/settings/filemanager.sh"
    fi
    _selectCategory
fi
