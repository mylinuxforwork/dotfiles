# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

echo "IMPORTANT: Please make sure that your system and your packages are up to date."
echo "You can cancel the installation at any time with CMD + C"
echo ""
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
if [ $SCRIPTPATH = "/home/$USER/dotfiles" ]; then
    echo "IMPORTANT: You're running the installation script from the installation target directory."
    echo "Please move the installation folder dotfiles e.g. to ~/Downloads/ and start the script again."
    echo "Proceeding is not recommended!"
    echo ""
    if [ ! $mode == "dev" ]; then
        exit
    fi
fi

while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""
