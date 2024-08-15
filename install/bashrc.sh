# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

if [ -f ~/.bashrc ] ;then
    if ! test -L ~/.bashrc ;then
        echo -e "${GREEN}"
        figlet ".bashrc"
        echo -e "${NONE}"
        echo ":: The script has detected an existing .bashrc file."
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
fi
echo 
