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

echo -e "${GREEN}"
figlet "Hyprland"
echo -e "${NONE}"
source $packages_directory/hyprland.sh
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";
