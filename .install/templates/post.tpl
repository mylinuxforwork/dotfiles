#!/bin/bash
# ------------------------------------------------------
# Don't edit this section
# Include scripts.sh with helper functions
source library/scripts.sh
# ------------------------------------------------------

# Show Current version
echo ":: Running hook for ML4W Dotfiles $version"

# Install additional packages
_installPackagesPacman "kitty";
_installPackagesYay "wlogout";
_installPackagesFlatpak "ccom.spotify.Client"

# Remove installed packages
# sudo pacman -R alacritty
