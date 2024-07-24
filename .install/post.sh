# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/post.sh ]; then
echo -e "${GREEN}"
figlet "Post Script"
echo -e "${NONE}"
    echo ":: The script has detected a post.sh script."
    echo
    if gum confirm "Do you want to run the script now?"; then
        cd ~/dotfiles-versions
        ~/dotfiles-versions/post.sh
        cd $install_directory
        echo ":: post.sh executed!"
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Execution of post.sh skipped."
    fi
fi
