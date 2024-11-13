#!/bin/bash
#  __  __ _    _  ___        __  ____        _    __ _ _           
# |  \/  | |  | || \ \      / / |  _ \  ___ | |_ / _(_) | ___  ___ 
# | |\/| | |  | || |\ \ /\ / /  | | | |/ _ \| __| |_| | |/ _ \/ __|
# | |  | | |__|__   _\ V  V /   | |_| | (_) | |_|  _| | |  __/\__ \
# |_|  |_|_____| |_|  \_/\_/    |____/ \___/ \__|_| |_|_|\___||___/
#                                                                 
# for Hyprland

# ----------------------------------------------------- 
# Installation
# -----------------------------------------------------

source_directory="$(dirname $(pwd))"
source_bin_directory="$source_directory/bin"
source_share_directory="$source_directory/share"
source_lib_directory="$source_directory/lib"

package_name="ml4w-hyprland"
base_directory="/usr"
bin_directory="$base_directory/bin"
share_directory="$base_directory/share/$package_name"
lib_directory="$base_directory/lib/$package_name"

# bin
if [ ! -d $bin_directory ]; then
    sudo mkdir -p $bin_directory
fi
sudo cp $source_bin_directory/ml4w-hyprland-setup $bin_directory
echo ":: $source_bin_directory/ml4w-hyprland-setup installed"

#share
if [ ! -d $share_directory ]; then
    sudo mkdir -p $share_directory
fi
sudo cp -ar $source_share_directory/. $share_directory
echo ":: $share_directory installed"

#lib
if [ ! -d $lib_directory ]; then
    sudo mkdir -p $lib_directory
fi
sudo cp -ar $source_lib_directory/. $lib_directory 
echo ":: $lib_directory installed"

echo 

echo ":: ML4W Dotfiles installed successfully"