# ------------------------------------------------------
# Select installation profile
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Hyprland"
echo -e "${NONE}"

hyprland_installed=0
hyprlandgit_installed=0
hyprland_package=""
echo "Hyprland is available in two differnet versions: "
echo "hyprland with the lastest official release "
echo "hyprland-git compiled from latest source."
echo
echo "Check for installed hyprland package..."
if [[ $(_isInstalledYay "hyprland-git") == 0 ]]; then
    echo "hyprland-git already installed!"
    hyprlandgit_installed=1
elif [[ $(_isInstalledPacman "hyprland") == 0 ]]; then
    echo "hyprland already installed!"
    hyprland_installed=1
else
    echo "hyprland NOT installed!"
fi
echo
if [ $hyprland_installed == "1" ] ;then
    echo "Hyprland is already installed with the package hyprland on your system. How do you want to proceed?"
    echo "RETURN = confirm. ESC = Keep hyprland"
    hyprsel=$(gum choose "KEEP hyprland" "Replace with hyprland-git")
    if [ "$hyprsel" == "Replace with hyprland-git" ] ;then
        echo "Replace hyprland with hyprland-git."
        yay  --noconfirm -R hyprland
        _forcePackagesYay "hyprland-git";
    else
        echo "Keep current hyprland installation."
    fi
elif [ $hyprlandgit_installed == "1" ] ;then
    echo "Hyprland is already installed with the package hyprland-git on your system. How do you want to proceed?"
    echo "RETURN = confirm. ESC = Keep hyprland-git"
    hyprsel=$(gum choose "KEEP hyprland-git" "Replace with hyprland")
    if [ "$hyprsel" == "Replace with hyprland" ] ;then
        echo "Replace hyprland-git with hyprland."
        yay  --noconfirm -R hyprland-git
        _forcePackagesYay "hyprland";
    else
        echo "Keep current hyprland installation."
    fi
else
    # No hyprland found on the system
    echo "RETURN = confirm. No selection = CANCEL"
    hypr_version=$(gum choose "hyprland" "hyprland-git")
    if [ -z $hypr_version ] ;then
        echo "No profile selected. Installation canceled."
        exit
    fi
    if [ "$hypr_version" == "hyprland" ] ;then
        _installPackagesYay "hyprland";
    else
        _installPackagesYay "hyprland-git";
    fi
fi
