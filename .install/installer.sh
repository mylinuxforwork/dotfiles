# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Packages"
echo -e "${NONE}"
if [ -d ~/dotfiles ] ;then
    echo "Do you want to check for new packages only (faster installation)"
    echo "or do you want to reinstall all packages again? (more robust and can help to fix issues)"
    if gum confirm "How do you want to proceed?" --affirmative "New packages only" --negative "Force reinstallation" ;then
        force_install=0
    elif [ $? -eq 130 ]; then
        echo "Installation canceled."
        exit 130
    else
        force_install=1
    fi
else
    echo "Do you want to reinstall all already installed packages and install the required new packages? (recommended and more robust)"
    echo "or do you want to install the new required packages only? (could be faster installation)"
    if gum confirm "How do you want to proceed?" --affirmative "Reinstall all packages" --negative "Install new packages only" ;then
        force_install=1
    elif [ $? -eq 130 ]; then
        echo "Installation canceled."
        exit 130
    else
        force_install=0
    fi
fi
