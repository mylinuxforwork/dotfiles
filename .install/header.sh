echo -e "${GREEN}"
cat <<"EOF"
 __  __ _    _  ___        __  ____        _    __ _ _           
|  \/  | |  | || \ \      / / |  _ \  ___ | |_ / _(_) | ___  ___ 
| |\/| | |  | || |\ \ /\ / /  | | | |/ _ \| __| |_| | |/ _ \/ __|
| |  | | |__|__   _\ V  V /   | |_| | (_) | |_|  _| | |  __/\__ \
|_|  |_|_____| |_|  \_/\_/    |____/ \___/ \__|_| |_|_|\___||___/
                                                                 
EOF
echo -e "${NONE}"

echo "Version: $version"
echo "by Stephan Raabe 2024"
echo ""
echo ":: You're running the script in $install_directory"
if [ -d ~/dotfiles ] ;then
    echo ":: An existing ML4W Dotfiles installation has been detected."
    echo ":: This script will guide you through the update process of the ML4W Dotfiles."
else
    echo ":: This script will guide you through the installation process of the ML4W dotfiles."
fi
echo ""