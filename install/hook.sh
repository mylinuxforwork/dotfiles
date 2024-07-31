# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/hook.sh ]; then
echo -e "${GREEN}"
figlet "Hook Script"
echo -e "${NONE}"
    echo ":: The script has detected a hook.sh script."
    echo
    if gum confirm "Do you want to run the script now?"; then
        cd ~/dotfiles-versions
        ~/dotfiles-versions/hook.sh
        cd $install_directory
        echo ":: hook.sh executed!"
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Execution of hook.sh skipped."
    fi
fi
