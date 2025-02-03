#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Browser"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/browser.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "browser.sh"

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ]; then
    _selectCategory
elif [ $optionalSelect == "CANCEL" ]; then
    _selectCategory
else
    if [[ ! $(_isInstalled "$optionalSelect") == 0 ]]; then
        _installPackage $optionalSelect
    fi
    if [ $optionalSelect == "brave-bin" ]; then
        echo 'brave' > "$HOME/.config/ml4w/settings/browser.sh"
    elif [ $optionalSelect == "brave-browser" ]; then
        echo 'brave' > "$HOME/.config/ml4w/settings/browser.sh"
    elif [ $optionalSelect == "zen-browser-bin" ]; then
        echo 'zen-browser' > "$HOME/.config/ml4w/settings/browser.sh"
    else
        echo "$optionalSelect" > "$HOME/.config/ml4w/settings/browser.sh"
    fi
    _selectCategory
fi
