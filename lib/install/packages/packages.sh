# ------------------------------------------------------
# Install packages
# ------------------------------------------------------
_writeLogHeader "Packages"
_writeHeader "Packages"

# Hyprland
source $packages_directory/$install_platform/hyprland.sh
_installPackages "${packages[@]}"

# profile
source $packages_directory/$install_platform/profiles/default.sh
_installPackages "${packages[@]}"
