# ------------------------------------------------------
# Install .zshrc
# ------------------------------------------------------

if [ -f ~/.zshrc ] ;then
    if ! test -L ~/.zshrc ;then
        echo -e "${GREEN}"
        figlet ".zshrc"
        echo -e "${NONE}"
        echo ":: The script has detected an existing .zshrc file."
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version (Recommended)."
        echo
        if gum confirm "Do you want to replace your existing .zshrc?" ;then
            rm ~/.zshrc
            echo ":: .zshrc will be installed"
        elif [ $? -eq 130 ]; then
                exit 130
        else
            echo ":: Installation of the .zshrc file skipped."
        fi
    fi
fi
echo
