# ------------------------------------------------------
# Select installation profile
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Profile"
echo -e "${NONE}"
echo "Please select your installation profile."
echo
profile=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "Hyprland" "Qtile")

if [ -z "${profile}" ] ;then
    echo ":: No profile selected. Installation canceled."
    exit
else
    echo ":: Profile/s selected:" $profile
fi

# Install selected profiles
if [[ $profile == *"Hyprland"* ]]; then
    echo -e "${GREEN}"
    figlet "Hyprland"
    echo -e "${NONE}"
    source .install/packages/hyprland-packages.sh
    source .install/install_packages.sh
fi
if [[ $profile == *"Qtile"* ]]; then
    echo -e "${GREEN}"
    figlet "Qtile"
    echo -e "${NONE}"
    source .install/packages/qtile-packages.sh
    source .install/install_packages.sh
fi
