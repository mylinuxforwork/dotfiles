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
fi
if [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
    bash_confirm="Do you want to replace your existing .bashrc file with the dotfiles .bashrc file?"
    if gum confirm "$bash_confirm" ;then
        rm ~/.bashrc
        _installSymLink .bashrc ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc
    elif [ $? -eq 130 ]; then
            exit 130
    else
        echo "Installation of the .bashrc file skipped."
    fi
else
    bash_confirm="Do you want to install the dotfiles .bashrc file now?"
    if gum confirm "$bash_confirm" ;then
        if [ -L ~/.bashrc ] || [ -f ~/.bashrc ]; then
            rm ~/.bashrc
            echo "Existing .bashrc removed."
        fi
        _installSymLink .bashrc ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc
    elif [ $? -eq 130 ]; then
            exit 130
    else
        echo "Installation of the .bashrc file skipped."
    fi
fi
echo ""
