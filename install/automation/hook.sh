if [[ "$automation_hook" = true ]] ;then
    if [ -f ~/dotfiles-versions/hook.sh ]; then
        echo -e "${GREEN}"
        figlet "Hook Script"
        echo -e "${NONE}"
        cd ~/dotfiles-versions
        ~/dotfiles-versions/hook.sh
        cd $install_directory
        echo ":: AUTOMATION: hook.sh executed!"
        echo
    fi
elif [[ "$automation_hook" = false ]] ;then
    echo ":: AUTOMATION: hook.sh skipped"
    echo
else
    echo ":: AUTOMATION ERROR: hook error"
fi