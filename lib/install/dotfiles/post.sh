# ------------------------------------------------------
# Execute post.sh
# ------------------------------------------------------

if [ -f $ml4w_directory/post.sh ]; then
    echo -e "${GREEN}"
    figlet -f smslant "Post Script"
    echo -e "${NONE}"
    echo ":: The script has detected a post.sh script."
    echo
    if [ -z $automation_post ] ;then
        if gum confirm "Do you want to run the script now?"; then
            cd $ml4w_directory
            ./post.sh
            cd $base_directory
            echo ":: post.sh executed!"
        elif [ $? -eq 130 ]; then
            echo ":: Installation canceled."
            exit 130
        else
            echo ":: Execution of post.sh skipped."
        fi
    else
        if [[ "$automation_post" = true ]] ;then
            cd $ml4w_directory
            ./post.sh
            cd $base_directory
            echo ":: AUTOMATION: post.sh executed!"
        elif [[ "$automation_post" = false ]] ;then
            echo ":: AUTOMATION: post.sh skipped"
        else
            echo ":: AUTOMATION ERROR: post error"
        fi
    fi
fi
