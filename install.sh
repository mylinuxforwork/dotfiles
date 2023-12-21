#!/bin/bash
source .install/version.sh
source .install/colors.sh
source .install/library.sh
clear

# Set installation mode
mode="live"
if [ ! -z $1 ]; then
    mode="dev"
    echo "IMPORTANT: DEV MODE ACTIVATED. "
    echo "Existing dotfiles folder will not be modified."
    echo "Symbolic links will not be created."
fi
echo -e "${GREEN}"
cat <<"EOF"
 __  __ _    _  ___        __      _       _    __ _ _           
|  \/  | |  | || \ \      / /   __| | ___ | |_ / _(_) | ___  ___ 
| |\/| | |  | || |\ \ /\ / /   / _` |/ _ \| __| |_| | |/ _ \/ __|
| |  | | |__|__   _\ V  V /   | (_| | (_) | |_|  _| | |  __/\__ \
|_|  |_|_____| |_|  \_/\_/     \__,_|\___/ \__|_| |_|_|\___||___/
                                                                 
EOF
echo -e "${NONE}"

echo "Version: $version"
echo "by Stephan Raabe 2023"
echo ""
echo "This script will guide you through the installation process of my dotfiles."
echo ""
source .install/required.sh
source .install/confirm-start.sh
source .install/backup.sh
source .install/preparation.sh
source .install/profile.sh
source .install/yay.sh
if [[ $profile == *"Hyprland"* ]]; then
    source .install/hyprland.sh
    source .install/hyprland-packages.sh
    source .install/install-packages.sh
fi
if [[ $profile == *"Qtile"* ]]; then
    source .install/qtile.sh
    source .install/qtile-packages.sh
    source .install/install-packages.sh
fi
source .install/pywal.sh
source .install/wallpaper.sh
source .install/displaymanager.sh
source .install/issue.sh
source .install/restore.sh
source .install/vm.sh
source .install/keyboard.sh
source .install/hook.sh
source .install/copy.sh
source .install/config-folder.sh
source .install/init-pywal.sh
if [[ $profile == *"Hyprland"* ]]; then
    source .install/hyprland-dotfiles.sh
fi
if [[ $profile == *"Qtile"* ]]; then
    source .install/qtile-dotfiles.sh
fi
source .install/bashrc.sh
source .install/monitor.sh
source .install/done.sh
