# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/hook.sh ]; then
echo -e "${GREEN}"
figlet "Hook"
echo -e "${NONE}"
    echo ":: The script has detected a hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/hook.sh
        echo ":: hook.sh executed!"
    else
        echo ":: Execution of hook.sh skipped."
    fi
fi
