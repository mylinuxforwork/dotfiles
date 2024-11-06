# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
_writeLogHeader "Confirm installation/update"

if [[ $(_check_update) == "true" ]] ;then
    if gum confirm "DO YOU WANT TO START THE UPDATE NOW?" ;then
        _writeLogTerminal 0 "Update started"
    elif [ $? -eq 130 ]; then
        _writeLogTerminal 0 "Update canceled."
        exit 130
    else
        _writeLogTerminal 0 "Update canceled."
        exit;
    fi
else
    if gum confirm "DO YOU WANT TO INSTALL THE REQUIRED PACKAGES FOR ML4W Dotfiles?" ;then
        _writeLogTerminal 0 "Installation started"
    elif [ $? -eq 130 ]; then
        _writeLogTerminal 0 "Installation canceled."
        exit 130
    else
        _writeLogTerminal 0 "Installation canceled."
        exit;
    fi
fi
echo
