#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "System Monitor"
echo -e "${NONE}"
source $packages_directory/options/system-monitor.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "system-monitor.sh"

optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ] ;then
    _selectCategory
elif [ $optionalSelect == "CANCEL" ]; then
    _selectCategory
else
    if [[ ! $(_isInstalledAUR "$optionalSelect") == 0 ]]; then
        $aur_helper -S $optionalSelect
    fi
    if [ $optionalSelect == "htop" ]; then
        echo '$(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e htop' > "$HOME/.config/ml4w/settings/system-monitor.sh"
    elif [ $optionalSelect == "btop" ]; then
        echo '$(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e btop' > "$HOME/.config/ml4w/settings/system-monitor.sh"
    else
        echo "$optionalSelect" > "$HOME/.config/ml4w/settings/system-monitor.sh"
    fi
    _selectCategory
fi