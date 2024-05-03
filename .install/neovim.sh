# ------------------------------------------------------
# Neovim
# ------------------------------------------------------
neovim=0
if [ -d ~/dotfiles/nvim ]; then
echo -e "${GREEN}"
figlet "Neovim"
echo -e "${NONE}"
    echo ":: The script has detected a nvim folder."
    if gum confirm "Do you want to install the ML4W Neovim configuration?"; then
        echo ":: ML4W Neovim configuration will be installed"
        neovim=1
    else
        rm -rf ~/dotfiles-versions/$version/nvim/
        echo ":: Installation of ML4W Neovim configuration skipped."
    fi
fi
