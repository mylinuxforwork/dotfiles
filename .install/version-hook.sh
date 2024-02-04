# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/$version/version-hook.sh ]; then
    echo -e "${GREEN}"
    figlet "Version Hook"
    echo -e "${NONE}"
    echo ":: The script has detected a version-hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/$version/version-hook.sh
        echo ":: version-hook.sh executed!"
    else
        echo ":: Execution of version-hook.sh skipped."
    fi
fi
