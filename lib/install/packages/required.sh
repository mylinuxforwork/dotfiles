# ------------------------------------------------------
# Check for required packages to run the installation
# ------------------------------------------------------

# Check for required packages
echo "Checking that required packages for the installation are installed..."
_installPackagesPacman "rsync" "gum" "figlet" "python" "git";

# Double check rsync
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo