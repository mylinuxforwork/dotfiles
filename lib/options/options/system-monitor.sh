#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "System Monitor"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/system-monitor.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "system-monitor.sh"

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
    if [ $optionalSelect == "htop" ]; then
        echo '$(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e htop' >"$HOME/.config/ml4w/settings/system-monitor.sh"
    elif [ $optionalSelect == "btop" ]; then
        echo '$(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e btop' >"$HOME/.config/ml4w/settings/system-monitor.sh"
    else
        echo "$optionalSelect" >"$HOME/.config/ml4w/settings/system-monitor.sh"
    fi
    _selectCategory
fi
