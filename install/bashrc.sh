# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

echo -e "${GREEN}"
figlet ".bashrc"
echo -e "${NONE}"

if grep -q "ML4W bashrc loader" ~/.bashrc; then
    echo ":: ML4W bashrc loader detected."
else
    echo ":: The script has detected an existing .bashrc file."
    if [ -f ~/dotfiles-versions/backups/$datets/.bashrc-old ]; then
        echo "Backup is already available here ~/dotfiles-versions/backups/$datets/.bashrc-old"
        echo
    fi
    echo ":: You can replace it with the latest version of ML4W Dotfiles $version (Recommended)."
    echo
    if gum confirm "Do you want to replace your existing .bashrc?" ;then
        rm ~/.bashrc
        echo ":: .bashrc will be installed"
    elif [ $? -eq 130 ]; then
            exit 130
    else
        echo ":: Installation of the .bashrc file skipped."
    fi
fi
echo 
