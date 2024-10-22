# ------------------------------------------------------
# Install packages
# ------------------------------------------------------

echo -e "${GREEN}"
figlet -f smslant "Packages"
echo -e "${NONE}"

# Hyprland
source $packages_directory/hyprland.sh
_installPackagesAUR "${packages[@]}";

# profile
source $packages_directory/profiles/default.sh
_installPackagesAUR "${packages[@]}";
