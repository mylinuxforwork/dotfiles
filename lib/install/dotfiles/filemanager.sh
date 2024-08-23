# ------------------------------------------------------
# File Manager
# ------------------------------------------------------

if [[ $(_check_update) == "false" ]] ;then
    if [[ ! $(_isInstalledPacman "nautilus") == 0 ]]; then
        echo -e "${GREEN}"
        figlet "File Manager"
        echo -e "${NONE}"
        echo ":: Nautilus is the recommended file manager for the ML4W Dotfiles."
        echo ":: You can install Nautilus now or configure your file manager later."
        echo
        if gum confirm "Do you want to install Nautilus now?" ;then
            sudo pacman --noconfirm -S nautilus
        fi
    fi
fi