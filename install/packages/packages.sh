# ------------------------------------------------------
# Install packages
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Packages"
echo -e "${NONE}"

# General packages
source $packages_directory/general.sh
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";

# Hyprland packages
if [[ $profile == *"Hyprland"* ]]; then
    echo -e "${GREEN}"
    figlet "Hyprland"
    echo -e "${NONE}"
    source $packages_directory/hyprland.sh
    _installPackagesPacman "${packagesPacman[@]}";
    _installPackagesYay "${packagesYay[@]}";
fi

# Qtile packages
if [[ $profile == *"Qtile"* ]]; then
    echo -e "${GREEN}"
    figlet "Qtile"
    echo -e "${NONE}"
    source $packages_directory/qtile.sh
    _installPackagesPacman "${packagesPacman[@]}";
    _installPackagesYay "${packagesYay[@]}";
fi