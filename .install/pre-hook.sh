# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/pre-hook.sh ]; then
    echo -e "${GREEN}"
    figlet "pre-Hook"
    echo -e "${NONE}"
    echo ":: The script has detected a pre-hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/pre-hook.sh
        echo ":: pre-hook.sh executed!"
    else
        echo ":: Execution of pre-hook.sh skipped."
    fi
fi
