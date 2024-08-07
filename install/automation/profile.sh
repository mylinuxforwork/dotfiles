# ------------------------------------------------------
# Install selected profiles
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Profile"
echo -e "${NONE}"
profile=$automation_profile
if [ -z "${profile}" ] ;then
    echo ":: AUTOMATION ERROR: No profile selected. Installation canceled."
    exit
else
    echo ":: AUTOMATION: Profile/s selected:" $profile
    echo 
fi
if [[ $profile == *"Hyprland"* ]]; then
    echo ":: AUTOMATION: Profile Hyprland"
    source install/packages/hyprland-packages.sh
    source install/install_packages.sh
fi
if [[ $profile == *"Qtile"* ]]; then
    echo ":: AUTOMATION: Profile Qtile"
    source install/packages/qtile-packages.sh
    source install/install_packages.sh
fi