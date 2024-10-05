#!/bin/bash
echo -e "${GREEN}"
figlet -f smslant "Optional"
echo -e "${NONE}"
if [ -z "$automation_optional" ] || [ "$automation_optional" == "true" ]; then

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
        echo ":: (CTRL+C or deselect all to skip this step)"
        echo
        optionalSelect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedInstall" "$toInstall")
        if [ ! -z "$optionalSelect" ]; then
            $aur_helper -S "$optionalSelect"
        else
            echo ":: No optional packages selected"
        fi
    fi
else
    echo ":: AUTOMATION: Optional Packages skipped"
fi
echo
