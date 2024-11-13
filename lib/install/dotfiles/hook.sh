# ------------------------------------------------------
# Execute hook.sh
# ------------------------------------------------------
_writeLogHeader "Hook"

if [ -f $ml4w_directory/hook.sh ]; then
    _writeHeader "Hook Script"
    echo ":: The script has detected a hook.sh script."
    echo
    if [ -z $automation_hook ] ;then
        if gum confirm "Do you want to run the script now?"; then
            cd $ml4w_directory
            ./hook.sh
            cd $base_directory
            echo ":: hook.sh executed!"
        elif [ $? -eq 130 ]; then
            _writeCancel
            exit 130
        else
            _writeSkipped
        fi
    else
        if [[ "$automation_hook" = true ]] ;then
            cd $ml4w_directory
            ./hook.sh
            cd $base_directory
            echo ":: AUTOMATION: hook.sh executed!"
            echo
        elif [[ "$automation_hook" = false ]] ;then
            _writeSkipped
            echo
        else
            echo ":: AUTOMATION ERROR: hook error"
        fi
    fi
fi
