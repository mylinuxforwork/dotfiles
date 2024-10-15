# ------------------------------------------------------
# Execute hook.sh
# ------------------------------------------------------

if [ -f $ml4w_directory/hook.sh ]; then
    echo -e "${GREEN}"
    figlet -f smslant "Hook Script"
    echo -e "${NONE}"
    echo ":: The script has detected a hook.sh script."
    echo
    if [ -z $automation_hook ] ;then
        if gum confirm "Do you want to run the script now?"; then
            cd $ml4w_directory
            ./hook.sh
            cd $base_directory
            echo ":: hook.sh executed!"
        elif [ $? -eq 130 ]; then
            echo ":: Installation canceled."
            exit 130
        else
            echo ":: Execution of hook.sh skipped."
        fi
    else
        if [[ "$automation_hook" = true ]] ;then
            cd $ml4w_directory
            ./hook.sh
            cd $base_directory
            echo ":: AUTOMATION: hook.sh executed!"
            echo
        elif [[ "$automation_hook" = false ]] ;then
            echo ":: AUTOMATION: hook.sh skipped"
            echo
        else
            echo ":: AUTOMATION ERROR: hook error"
        fi
    fi
fi
