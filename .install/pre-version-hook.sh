# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/$version/pre-version-hook.sh ]; then
    echo -e "${GREEN}"
    figlet "Pre Version Hook"
    echo -e "${NONE}"
    echo ":: The script has detected a pre-version-hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/$version/pre-version-hook.sh
        echo ":: pre-version-hook.sh executed!"
    else
        echo ":: Execution of pre-version-hook.sh skipped."
    fi
fi
