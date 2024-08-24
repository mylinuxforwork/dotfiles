# ------------------------------------------------------
# Header
# ------------------------------------------------------
clear
echo -e "${GREEN}"
cat <<"EOF"
   __  _____  _____      __  ___       __  ____ __      
  /  |/  / / / / / | /| / / / _ \___  / /_/ _(_) /__ ___
 / /|_/ / /_/_  _/ |/ |/ / / // / _ \/ __/ _/ / / -_|_-<
/_/  /_/____//_/ |__/|__/ /____/\___/\__/_//_/_/\__/___/
                                                        
EOF
echo "for Hyprland"
echo -e "${NONE}"

echo "Version: $version"
echo "by Stephan Raabe"
echo
# echo ":: You're running the script in $(pwd)"
if [[ $(_check_update) == "true" ]] ;then
    echo ":: An existing ML4W Dotfiles installation has been detected."
    echo ":: This script will guide you through the update process of the ML4W Dotfiles."
else
    echo ":: This script will guide you through the installation process of the ML4W dotfiles."
fi
echo