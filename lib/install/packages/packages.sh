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

# additional (only for initial installation)
if [[ $(_check_update) == "true" ]]; then
    _writeLogTerminal 0 "Installation of additional packages skipped."
else
    source $packages_directory/$install_platform/profiles/addons.sh
    _installPackages "${packages[@]}"
fi
