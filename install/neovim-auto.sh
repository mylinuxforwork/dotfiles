# ------------------------------------------------------
# Neovim
# ------------------------------------------------------
if [ -d ~/dotfiles-versions/$version/dotfiles/.config/nvim ] ;then
    if [ -d ~/$dot_folder/nvim ]; then
        echo -e "${GREEN}"
        figlet "Neovim"
        echo -e "${NONE}"    
        if [[ "$automation_neovim" = true ]] ;then
            echo ":: AUTOMATION: neovim configuration will be installed."
        elif [[ "$automation_neovim" = false ]] ;then
            rm -rf ~/dotfiles-versions/$version/.config/nvim/
            echo ":: AUTOMATION: Installation of the neovim configuration skipped."
        else
            echo ":: AUTOMATION ERROR: Neovim."
            exit
        fi
    fi
fi