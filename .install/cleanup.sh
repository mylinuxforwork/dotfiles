# ------------------------------------------------------
# Install tty login and issue
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Cleanup"
echo -e "${NONE}"
# Check for ttf-ms-fonts
if [[ $(_isInstalledPacman "ttf-ms-fonts") == 0 ]]; then
    echo "The script has detected ttf-ms-fonts. This can cause conflicts with icons in Waybar."
    if gum confirm "Do you want to uninstall ttf-ms-fonts?" ;then
        sudo pacman --noconfirm -R ttf-ms-fonts
    fi
fi
echo "Cleanup done."