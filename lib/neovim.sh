# ------------------------------------------------------
# Neovim
# ------------------------------------------------------

if [ -d ~/$ml4w_directory/$version/dotfiles/.config/nvim ] ;then
    if [ -d ~/$dot_folder/nvim ]; then
        echo -e "${GREEN}"
        figlet "Neovim"
        echo -e "${NONE}"
        echo ":: The script has detected a nvim folder in your ~/$dot_folder folder."
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
        echo
        if [ -z $automation_copy ] ;then
            if gum confirm "Do you want to replace your configuration?"; then
                echo ":: ML4W Neovim configuration will be installed"
            elif [ $? -eq 130 ]; then
                echo ":: Installation canceled."
                exit 130
            else
                rm -rf ~/$ml4w_directory/$version/.config/nvim/
                echo ":: Installation of ML4W Neovim configuration skipped."
            fi
        else
            if [[ "$automation_neovim" = true ]] ;then
                echo ":: AUTOMATION: neovim configuration will be installed."
            elif [[ "$automation_neovim" = false ]] ;then
                rm -rf ~/$ml4w_directory/$version/.config/nvim/
                echo ":: AUTOMATION: Installation of the neovim configuration skipped."
            else
                echo ":: AUTOMATION ERROR: Neovim."
                exit
            fi
        fi
    fi
fi