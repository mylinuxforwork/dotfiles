# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

echo "IMPORTANT: Please make sure that your system and your packages are up to date."
echo "You can cancel the installation at any time with CMD + C"
echo "If you have already installed a window manager like sway, please backup your .config folder."
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
if [ $SCRIPTPATH = "/home/$USER/dotfiles" ]; then
    echo "IMPORTANT: You're running the installation script from the installation target directory."
    echo "Please move the installation folder dotfiles e.g. to ~/Downloads/ and start the script again."
    echo "Proceeding is not recommended!"
    if [ ! $mode == "dev" ]; then
        exit
    fi
fi

if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
    echo "Installation started."
elif [ $? -eq 130 ]; then
        exit 130
else
    echo "Installation canceled."
    exit;
fi
echo ""
