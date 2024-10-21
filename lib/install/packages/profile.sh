#!/bin/bash
echo -e "${GREEN}"
figlet -f smslant "Profile"
echo -e "${NONE}"
source $packages_directory/profiles/default.sh
toInstall=""
selectedInstall=""

_checkPackages() {
    for pkg in ${packagesProfile[@]}; do
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

if [[ ! "${toInstall[@]}" == "" ]] ; then
    echo ":: Installing missing packages."
    $aur_helper -S $toInstall
fi
echo 
