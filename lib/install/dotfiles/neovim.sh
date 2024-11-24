# ------------------------------------------------------
# Neovim
# ------------------------------------------------------
_writeLogHeader "Neovim"

if [ -z $automation_neovim ] ;then
    if [ -d $ml4w_directory/$version/.config/nvim ] ;then
        if [ -d ~/.config/nvim ]; then
            _writeHeader "Neovim"
            echo ":: The script has detected a nvim folder in your ~/.config folder."
            echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
            echo
            if gum confirm "Do you want to replace your configuration?"; then
                echo ":: ML4W Neovim configuration will be installed"
            elif [ $? -eq 130 ]; then
                _writeCancel
                exit 130
            else
                rm -rf $ml4w_directory/$version/.config/nvim/
                _writeSkipped
            fi
        fi
    fi
else
    if [[ "$automation_neovim" = true ]] ;then
        echo ":: AUTOMATION: neovim configuration will be installed."
    else
        rm -rf $ml4w_directory/$version/.config/nvim
        _writeSkipped
    fi
fi