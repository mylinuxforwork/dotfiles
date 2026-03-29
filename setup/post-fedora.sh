#!/usr/bin/env bash

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# ML4W Settings App
# --------------------------------------------------------------

bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/ml4w-dotfiles-settings/main/setup.sh)
rm $HOME/.local/share/ml4w-dotfiles-settings/quickshell/shared/Theme.qml  
ln -sf $HOME/.config/quickshell/shared/Theme.qml $HOME/.local/share/ml4w-dotfiles-settings/quickshell/shared/Theme.qml

# --------------------------------------------------------------
# Prebuild Packages
# --------------------------------------------------------------

source $repo_path/setup/_prebuilt.sh

echo "Installing eza v0.23.0"
# https://github.com/eza-community/eza/releases
sudo cp $repo_path/setup/packages/eza /usr/bin

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

# Installing Fedora development tools
sudo dnf group install -y development-tools
sudo dnf install -y python3-devel cairo-devel cairo-gobject-devel gobject-introspection-devel

echo ":: Installing packages with pip"
sudo pip install pywalfox
sudo pip install screeninfo

# Installing Waypaper from Git
sudo dnf remove -y waypaper
pipx install --force git+https://github.com/anufrievroman/waypaper

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------

sudo cp $repo_path/setup/scripts/grimblast /usr/bin

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source $repo_path/setup/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source $repo_path/setup/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source $repo_path/setup/_icons.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update
