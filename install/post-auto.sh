if [[ "$automation_post" = true ]] ;then
    if [ -f ~/dotfiles-versions/post.sh ]; then
        echo -e "${GREEN}"
        figlet "Post Script"
        echo -e "${NONE}"    
        cd ~/dotfiles-versions
        ~/dotfiles-versions/post.sh
        cd $install_directory
        echo ":: AUTOMATION: post.sh executed!"
    fi
elif [[ "$automation_post" = false ]] ;then
    echo ":: AUTOMATION: post.sh skipped"
else
    echo ":: AUTOMATION ERROR: post error"
fi