# ------------------------------------------------------
# Execute post.sh
# ------------------------------------------------------
_writeLogHeader "Post Script"

if [ -f $ml4w_directory/post.sh ]; then
    _writeHeader "Post Script"
    echo ":: The script has detected a post.sh script."
    echo
    if [ -z $automation_post ]; then
        if gum confirm "Do you want to run the script now?"; then
            cd $ml4w_directory
            ./post.sh
            cd $base_directory
            echo ":: post.sh executed!"
        elif [ $? -eq 130 ]; then
            _writeCancel
            exit 130
        else
            _writeSkipped
        fi
    else
        if [[ "$automation_post" = true ]]; then
            cd $ml4w_directory
            ./post.sh
            cd $base_directory
            echo ":: AUTOMATION: post.sh executed!"
        elif [[ "$automation_post" = false ]]; then
            _writeSkipped
        else
            echo ":: AUTOMATION ERROR: post error"
        fi
    fi
fi
