# ------------------------------------------------------
# Neovim
# ------------------------------------------------------
if [ -d ~/dotfiles-versions/$version/nvim ] ;then
    if [ -d ~/dotfiles/nvim ]; then
        echo -e "${GREEN}"
        figlet "Neovim"
        echo -e "${NONE}"
        echo ":: The script has detected a nvim folder in your ~/dotfiles folder."
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version."
        echo
        if gum confirm "Do you want to replace your configuration?"; then
            echo ":: ML4W Neovim configuration will be installed"
        elif [ $? -eq 130 ]; then
            echo ":: Installation canceled."
            exit 130
        else
            rm -rf ~/dotfiles-versions/$version/nvim/
            echo ":: Installation of ML4W Neovim configuration skipped."
        fi
    fi
fi