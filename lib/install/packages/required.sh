# ------------------------------------------------------
# Required packages
# ------------------------------------------------------
_writeLogHeader "Required packages"

# Required packages for the installer
source $packages_directory/installer.sh

# Install required packages
_writeMessage "Checking that required packages for the installer..."
_installPackages "${packages[@]}";
echo