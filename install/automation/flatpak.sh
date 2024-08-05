echo -e "${GREEN}"
figlet "Flatpak"
echo -e "${NONE}"
if [[ $(_isInstalledPacman "flatpak") == 0 ]]; then
    echo ":: AUTOMATION: Flatpak already installed"
else
    echo ":: AUTOMATION: Installinf Flatpak"
    _installPackagesPacman "flatpak";
fi