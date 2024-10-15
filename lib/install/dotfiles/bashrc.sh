# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

if [ -f ~/.bashrc ] ;then
    if ! test -L ~/.bashrc ;then
        echo -e "${GREEN}"
        figlet -f smslant ".bashrc"
        echo -e "${NONE}"
        echo ":: The script has detected an existing .bashrc file."
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version (Recommended)."
        echo
        if [ -z $automation_bashrc ] ;then
            if gum confirm "Do you want to replace your existing .bashrc?" ;then
                rm ~/.bashrc
                echo ":: .bashrc will be installed"
            elif [ $? -eq 130 ]; then
                    exit 130
            else
                echo ":: Installation of the .bashrc file skipped."
            fi
        else
            if [[ "$automation_bashrc" = true ]] ;then
                echo ":: AUTOMATION: .bashrc will be installed."
            elif [[ "$automation_bashrc" = false ]] ;then
                rm $ml4w_directory/$version/.bashrc
                echo ":: AUTOMATION: Installation of the .bashrc file skipped."
            else
                echo ":: AUTOMATION ERROR: bashrc"
                exit
            fi
        fi
    fi
fi
echo 
