# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

echo -e "${GREEN}"
figlet ".zshrc"
echo -e "${NONE}"

if [ -f ~/dotfiles-versions/$version/.zshrc ] ;then
    if [ -f ~/$dot_folder/.zshrc ] ;then
        if [[ "$automation_zshrc" = true ]] ;then
            echo ":: AUTOMATION: .zshrc will be installed."
        elif [[ "$automation_zshrc" = false ]] ;then
            rm ~/dotfiles-versions/$version/.zshrc
            echo ":: AUTOMATION: Installation of the .zshrc file skipped."
        else
            echo ":: AUTOMATION ERROR: zshrc"
            exit
        fi
    fi
fi