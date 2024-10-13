# ------------------------------------------------------
# Neovim
# ------------------------------------------------------

if [ -z $automation_kitty ] ;then
    if [ -d $ml4w_directory/$version/.config/kitty ] ;then
        if [ -d ~/.config/kitty ]; then
            echo -e "${GREEN}"
            figlet -f smslant "Kitty"
            echo -e "${NONE}"
            echo ":: The script has detected a kitty folder in your ~/.config folder."
            echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
            echo
            if gum confirm "Do you want to replace your configuration?"; then
                echo ":: ML4W Kitty configuration will be installed"
            elif [ $? -eq 130 ]; then
                echo ":: Installation canceled."
                exit 130
            else
                rm -rf $ml4w_directory/$version/.config/kitty
                if [ -d ~/$dot_folder/.config/kitty ] ;then
                    rm -rf ~/$dot_folder/.config/kitty
                fi
                echo ":: Installation of ML4W Kitty configuration skipped."
            fi
        fi
    fi
else
    if [[ "$automation_kitty" = true ]] ;then
        echo ":: AUTOMATION: Kitty configuration will be installed."
    else
        rm -rf $ml4w_directory/$version/.config/kitty
        if [ -d ~/$dot_folder/.config/kitty ] ;then
            rm -rf ~/$dot_folder/.config/kitty
        fi
        echo ":: AUTOMATION: Installation of the Kitty configuration skipped."
    fi
fi