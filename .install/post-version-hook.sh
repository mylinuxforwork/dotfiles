# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/post-version-hook.sh ]; then
    echo -e "${GREEN}"
    figlet "Post Version Hook"
    echo -e "${NONE}"
    echo ":: The script has detected a post-version-hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/post-version-hook.sh
        echo ":: post-version-hook.sh executed!"
    else
        echo ":: Execution of post-version-hook.sh skipped."
    fi
fi
