# ------------------------------------------------------
# Install packages
# ------------------------------------------------------
_writeLogHeader "Packages"
_writeHeader "Packages"

# Hyprland
source $packages_directory/hyprland.sh
_installPackages "${packages[@]}";

# profile
source $packages_directory/profiles/default.sh
_installPackages "${packages[@]}";
