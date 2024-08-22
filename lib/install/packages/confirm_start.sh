# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if [[ $(_check_update) == "true" ]] ;then
    if gum confirm "DO YOU WANT TO START THE UPDATE NOW?" ;then
        echo ":: Update started."
    elif [ $? -eq 130 ]; then
        echo ":: Update canceled."
        exit 130
    else
        echo ":: Update canceled."
        exit;
    fi
else
    if gum confirm "DO YOU WANT TO INSTALL THE REQUIRED PACKAGES FOR ML4W Dotfiles?" ;then
        echo ":: Installation started."
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Installation canceled."
        exit;
    fi
fi
echo
