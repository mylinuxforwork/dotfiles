# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/post-hook.sh ]; then
    echo -e "${GREEN}"
    figlet "post-Hook"
    echo -e "${NONE}"
    echo ":: The script has detected a post-hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/post-hook.sh
        echo ":: post-hook.sh executed!"
    else
        echo ":: Execution of post-hook.sh skipped."
    fi
fi
