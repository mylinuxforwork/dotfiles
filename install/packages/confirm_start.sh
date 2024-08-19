# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Packages"
echo -e "${NONE}"
if gum confirm "DO YOU WANT TO INSTALL THE REQUIRED PACKAGES FOR ML4W Dotfiles?" ;then
    echo "Installation started."
elif [ $? -eq 130 ]; then
    echo ":: Installation canceled."
    exit 130
else
    echo ":: Installation canceled."
    exit;
fi
echo ""
