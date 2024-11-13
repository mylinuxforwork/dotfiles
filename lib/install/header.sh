# ------------------------------------------------------
# Header
# ------------------------------------------------------
_writeLogHeader "Installation"
_writeLog 0 "Installation started"

clear
echo -e "${GREEN}"
cat <<"EOF"
   __  _____  _____      __  ___       __  ____ __      
  /  |/  / / / / / | /| / / / _ \___  / /_/ _(_) /__ ___
 / /|_/ / /_/_  _/ |/ |/ / / // / _ \/ __/ _/ / / -_|_-<
/_/  /_/____//_/ |__/|__/ /____/\___/\__/_//_/_/\__/___/
                                                        
EOF
echo "for Hyprland"
echo "by Stephan Raabe"
echo -e "${NONE}"

echo "Version: $version"
echo "Platform: $install_platform" 
echo
# echo ":: You're running the script in $(pwd)"
if [[ $(_check_update) == "true" ]] ;then
    _writeLog 0 "An existing ML4W Dotfiles installation detected."
    _writeMessage "This script will guide you through the update process of the ML4W Dotfiles."
else
    _writeLog 0 "Initial installation of ML4W Dotfiles started."
    _writeMessage "This script will guide you through the installation process of the ML4W dotfiles."
fi