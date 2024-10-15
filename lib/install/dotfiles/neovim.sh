# ------------------------------------------------------
# Neovim
# ------------------------------------------------------

if [ -z $automation_neovim ] ;then
    if [ -d $ml4w_directory/$version/.config/nvim ] ;then
        if [ -d ~/.config/nvim ]; then
            echo -e "${GREEN}"
            figlet -f smslant "Neovim"
            echo -e "${NONE}"
            echo ":: The script has detected a nvim folder in your ~/.config folder."
            echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
            echo
            if gum confirm "Do you want to replace your configuration?"; then
                echo ":: ML4W Neovim configuration will be installed"
            elif [ $? -eq 130 ]; then
                echo ":: Installation canceled."
                exit 130
            else
                rm -rf $ml4w_directory/$version/.config/nvim/
                if [ -d ~/$dot_folder/.config/nvim ] ;then
                    rm -rf ~/$dot_folder/.config/nvim
                fi
                echo ":: Installation of ML4W Neovim configuration skipped."
            fi
        fi
    fi
else
    if [[ "$automation_neovim" = true ]] ;then
        echo ":: AUTOMATION: neovim configuration will be installed."
    else
        rm -rf $ml4w_directory/$version/.config/nvim
        if [ -d ~/$dot_folder/.config/nvim ] ;then
            rm -rf ~/$dot_folder/.config/nvim
        fi
        echo ":: AUTOMATION: Installation of the neovim configuration skipped."
    fi
fi