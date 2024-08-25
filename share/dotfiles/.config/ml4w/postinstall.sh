#!/bin/bash
sleep 2
clear
if ! type "pacman" > /dev/null 2>&1; then
    echo ":: You're not on an Arch based distro"
    exit
fi

_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    # printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

echo -e "${GREEN}"
figlet -f smslant "Post Install"
echo -e "${NONE}"
echo ":: The script helps you to install additional packages for your ML4W Dotfiles."
echo
reboot=0

# Check for xdg-desktop-portal-gtk
if [[ $(_isInstalledPacman "xdg-desktop-portal-gtk") == 0 ]]; then
    echo ":: xdg-desktop-portal-gtk already installed"
else
    echo -e "${GREEN}"
    figlet -f smslant "Portal GTK"
    echo -e "${NONE}"
    echo "xdg-desktop-portal-gtk is required to use dark mode in GTK4 Apps." 
    echo
    if gum confirm "Do you want to install xdg-desktop-portal-gtk?"; then
        _installPackagesPacman "xdg-desktop-portal-gtk";
        reboot=1
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Installation of xdg-desktop-portal-gtk skipped."
        exit
    fi
fi

# Select shell
source ~/.config/ml4w/scripts/shell.sh

# Reboot
clear
echo -e "${GREEN}"
figlet -f smslant "Reboot"
echo -e "${NONE}"
echo "A reboot of your system is recommended."
echo
if gum confirm "Do you want to reboot your system now?" ;then
    gum spin --spinner dot --title "Rebooting now..." -- sleep 3
    systemctl reboot
elif [ $? -eq 130 ]; then
    exit 130
else
    gum spin --spinner dot --title "Reboot skipped..." -- sleep 3
fi
echo ""
