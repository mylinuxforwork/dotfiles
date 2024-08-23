# ------------------------------------------------------
# Browser
# ------------------------------------------------------

if [[ $(_check_update) == "false" ]] ;then
    if [[ ! $(_isInstalledPacman "firefox") == 0 ]]; then
        echo -e "${GREEN}"
        figlet "Browser"
        echo -e "${NONE}"
        echo ":: Firefox is the recommended browser for the ML4W Dotfiles."
        echo ":: You can install Firefox now or configure your browser later."
        echo
        if gum confirm "Do you want to install Firefox now?" ;then
            sudo pacman --noconfirm -S firefox
        fi
    fi
fi