# ------------------------------------------------------
# Before Start
# ------------------------------------------------------

if [ -d ~/dotfiles-versions ] ;then
    mv ~/dotfiles-versions $ml4w_directory
    echo ":: PLEASE NOTE: ~/dotfiles-versions folder renamed to $ml4w_directory"
fi
if [ -d ~/.ml4w-dotfiles ] ;then
    mv ~/.ml4w-dotfiles $ml4w_directory
    echo ":: PLEASE NOTE: ~/.ml4w-dotfiles folder renamed to $ml4w_directory"
fi

# Install required packages for the installer if in filesystem mode
if [ "$install_mode" == "filesystem" ] ;then

    # Required packages for the installer
    source $packages_directory/installer.sh

    # Install required packages
    echo ":: Checking that required packages for the installer..."
    _installPackagesPacman "${packages[@]}";

    echo
fi