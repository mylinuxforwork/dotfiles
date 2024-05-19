# ------------------------------------------------------
# Shell Configuration
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Shell configuration"
echo -e "${NONE}"
if gum confirm "What shell do you want to use?" --affirmative "bash" --negative "zsh"; then
    if [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
        echo "PLEASE NOTE: The script has detected an existing .bashrc file."
    fi
    if [ -f ~/dotfiles-versions/backups/$datets/.bashrc-old ]; then
        echo "Backup is already available here ~/dotfiles-versions/backups/$datets/.bashrc-old"
    fi
    if [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
        bash_confirm="Do you want to replace your existing .bashrc file with the ML4W dotfiles .bashrc file?"
        if gum confirm "$bash_confirm" ;then
            rm ~/.bashrc
            _installSymLink .bashrc ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc
        elif [ $? -eq 130 ]; then
                exit 130
        else
            echo "Installation of the .bashrc file skipped."
        fi
    else
        bash_confirm="Do you want to install the ML4W dotfiles .bashrc file now?"
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
else
    if [ ! -L ~/.zshrc ] && [ -f ~/.zshrc ]; then
        echo "PLEASE NOTE: The script has detected an existing .zshrc file."
    fi
    if [ -f ~/dotfiles-versions/backups/$datets/.zshrc-old ]; then
        echo "Backup is already available here ~/dotfiles-versions/backups/$datets/.zshrc-old"
    fi
    if [ ! -L ~/.zshrc ] && [ -f ~/.zshrc ]; then
        bash_confirm="Do you want to replace your existing .zshrc file with the ML4W dotfiles .zshrc file?"
        if gum confirm "$bash_confirm" ;then
            rm ~/.zshrc
            _installSymLink .zshrc ~/.zshrc ~/dotfiles/.zshrc ~/.zshrc
            _installPackagesPacman "fzf" "zoxide"
            chsh -s /bin/zsh
        elif [ $? -eq 130 ]; then
                exit 130
        else
            echo "Installation of the .zshrc file skipped."
        fi
    else
        bash_confirm="Do you want to install the ML4W dotfiles .zshrc file now?"
        if gum confirm "$bash_confirm" ;then
            if [ -L ~/.zshrc ] || [ -f ~/.zshrc ]; then
                rm ~/.zshrc
                echo "Existing .zshrc removed."
            fi
            _installSymLink .zshrc ~/.zshrc ~/dotfiles/.zshrc ~/.zshrc
            _installPackagesPacman "fzf" "zoxide"
            chsh -s /bin/zsh
        elif [ $? -eq 130 ]; then
                exit 130
        else
            echo "Installation of the .zshrc file skipped."
        fi
    fi
    echo ""
fi
