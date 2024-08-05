# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo -e "${GREEN}"
figlet ".bashrc"
echo -e "${NONE}"

if [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
    echo "PLEASE NOTE: The script has detected an existing .bashrc file."
fi
if [ -f ~/dotfiles-versions/backups/$datets/.bashrc-old ]; then
    echo "Backup is already available here ~/dotfiles-versions/backups/$datets/.bashrc-old"
    echo
fi
if [ -f ~/dotfiles-versions/$version/.bashrc ] ;then
    if [ -f ~/$dot_folder/.bashrc ] ;then
        echo ":: The script has detected an existing .bashrc in your ~/$dot_version folder."
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
        echo
        if gum confirm "Do you want to replace your existing .bashrc?" ;then
            echo ":: .bashrc will be installed"
        elif [ $? -eq 130 ]; then
                exit 130
        else
            rm ~/dotfiles-versions/$version/.bashrc
            echo ":: Installation of the .bashrc file skipped."
        fi
    elif [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
        echo ":: The script has detected an existing .bashrc file."
        if [ -f ~/dotfiles-versions/backups/$datets/.bashrc-old ]; then
            echo "Backup is already available here ~/dotfiles-versions/backups/$datets/.bashrc-old"
            echo
        fi
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
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
fi
