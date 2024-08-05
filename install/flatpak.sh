# ------------------------------------------------------
# Flatpak
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Flatpak"
echo -e "${NONE}"

if [[ $(_isInstalledPacman "flatpak") == 0 ]]; then
    echo ":: Flatpak already installed"
else
    echo "Flatpak is a framework for distributing desktop applications across various Linux distributions." 
    echo "Flatpak applications: these are the applications the user installs via the flatpak command"
    echo
    if gum confirm "Do you want to install flatpak?"; then
        _installPackagesPacman "flatpak";
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Installation of flatpak skipped."
    fi
fi
