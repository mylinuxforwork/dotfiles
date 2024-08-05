# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo -e "${GREEN}"
figlet ".bashrc"
echo -e "${NONE}"

if [ -f ~/dotfiles-versions/$version/.bashrc ] ;then
    if [ -f ~/$dot_folder/.bashrc ] ;then
        if [[ "$automation_bashrc" = true ]] ;then
            echo ":: AUTOMATION: .bashrc will be installed."
        elif [[ "$automation_bashrc" = false ]] ;then
            rm ~/dotfiles-versions/$version/.bashrc
            echo ":: AUTOMATION: Installation of the .bashrc file skipped."
        else
            echo ":: AUTOMATION ERROR: bashrc"
            exit
        fi
    fi
fi