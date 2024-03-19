# ------------------------------------------------------
# Update System
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "System Update"
echo -e "${NONE}"
echo "It's important that your system is up-to-date before you proceed with the installation of the ML4W Dotfiles."
if gum confirm "Do you want to update the packages of your system with yay now?" ;then
    yay
fi
