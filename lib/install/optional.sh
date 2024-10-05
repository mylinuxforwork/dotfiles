#!/bin/bash
sleep 1
clear
echo -e "${GREEN}"
figlet -f smslant "Optional"
echo -e "${NONE}"
aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
echo "This script will help you to install optional packages."
echo "You can set the default applications in the ML4W Settings App."
echo
source "$packages_directory"/optional.sh
toInstall=""
selectedInstall=""

_checkPackages() {
    for pkg in ${optdepends[@]}; do
        if [[ $(_isInstalledAUR "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        else
            toInstall+="${pkg} "
            selectedInstall+="${pkg},"
        fi
    done
}

_checkPackages

if [[ "${toInstall[@]}" == "" ]]; then
    echo ":: All optional packages are already installed."
else
    echo
    echo ":: The following optional packages are currently not installed."
    echo ":: Please select the packages that you want to install and confirm with ENTER."
    echo ":: (CTRL+C or deselect all to cancel)"
    echo
    optionalSelect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedInstall" "$toInstall")
    if [ ! -z "$optionalSelect" ]; then
        $aur_helper -S "$optionalSelect"
    else
        echo ":: No optional packages selected"
    fi
fi
echo
