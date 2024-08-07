echo -e "${GREEN}"
figlet "Packages"
echo -e "${NONE}"
source install/packages/general-packages.sh
source install/install_packages.sh

# Install selected profiles
if [[ $profile == *"Hyprland"* ]]; then
    echo -e "${GREEN}"
    figlet "Hyprland"
    echo -e "${NONE}"
    source install/packages/hyprland-packages.sh
    source install/install_packages.sh
fi
if [[ $profile == *"Qtile"* ]]; then
    echo -e "${GREEN}"
    figlet "Qtile"
    echo -e "${NONE}"
    source install/packages/qtile-packages.sh
    source install/install_packages.sh
fi