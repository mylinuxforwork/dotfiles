# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/hook.sh ]; then
figlet "Hook"
    echo "The script has detected a hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/hook.sh
        echo "hook.sh executed!"
    fi
fi
