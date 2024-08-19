# ------------------------------------------------------
# Install packages
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Packages"
echo -e "${NONE}"
source $lib_directory/packages/general-packages.sh
source $lib_directory/install_packages.sh

# Install selected profiles
if [[ $profile == *"Hyprland"* ]]; then
    echo -e "${GREEN}"
    figlet "Hyprland"
    echo -e "${NONE}"
    source $lib_directory/packages/hyprland-packages.sh
    source $lib_directory/install_packages.sh
fi
if [[ $profile == *"Qtile"* ]]; then
    echo -e "${GREEN}"
    figlet "Qtile"
    echo -e "${NONE}"
    source $lib_directory/packages/qtile-packages.sh
    source $lib_directory/install_packages.sh
fi