# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if [ -f ~/.config/ml4w/settings/dotfiles-folder.sh ] && [ -d ~/dotfiles ] ;then
    if gum confirm "DO YOU WANT TO START THE UPDATE OF YOUR ML4W DOTFILES NOW?" ;then
        echo ":: Update started."
    elif [ $? -eq 130 ]; then
        echo ":: Update canceled."
        exit 130
    else
        echo ":: Update canceled."
        exit;
    fi
else
    if gum confirm "DO YOU WANT TO START THE INSTALLATION OF THE ML4W DOTFILES NOW?" ;then
        echo "Installation started."
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Installation canceled."
        exit;
    fi
fi
echo ""
