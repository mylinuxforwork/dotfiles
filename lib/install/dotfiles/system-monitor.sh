# ------------------------------------------------------
# System Monitor
# ------------------------------------------------------

if [[ $(_check_update) == "false" ]] ;then
    if [[ ! $(_isInstalledPacman "mission-center") == 0 ]]; then
        echo -e "${GREEN}"
        figlet "System Monitor"
        echo -e "${NONE}"
        echo ":: Mission Center is the recommended system monitor for the ML4W Dotfiles."
        echo ":: You can install Mission Center now or configure your system monitor later."
        echo
        if gum confirm "Do you want to install Mission Center now?" ;then
            $aur_helper --noconfirm -S mission-center
        fi
    fi
fi