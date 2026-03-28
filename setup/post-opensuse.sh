#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# Quickshell
# --------------------------------------------------------------
sudo zypper install quickshell

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

source $SCRIPT_DIR/_prebuilt.sh

# --------------------------------------------------------------
# Install eza
# --------------------------------------------------------------

echo "Installing eza"
sudo zypper ar https://download.opensuse.org/tumbleweed/repo/oss/ factory-oss
sudo zypper -n install eza

# --------------------------------------------------------------
# JetBrains Mono Nerd Font
# --------------------------------------------------------------

sudo zypper addrepo https://download.opensuse.org/repositories/X11:fonts/openSUSE_Factory/X11:fonts.repo
sudo zypper -n install jetbrainsmono-nerd-fonts

# --------------------------------------------------------------
# Install waypaper dependencies before using pip
# --------------------------------------------------------------

sudo zypper -n install gcc pkg-config cairo-devel gobject-introspection-devel libgirepository-1_0-1-devel python3-devel libgtk-4-devel typelib-1_0-Gtk-4_0 python313-screeninfo

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
pipx install pywalfox

# Installing Waypaper from Git
echo ":: Installing Waypaper from Git"
sudo zypper install -n -t pattern devel_basis
sudo zypper install -n python3-devel
sudo zypper install -n python313-pycairo-devel 
sudo zypper install -n python313-gobject-devel
pipx install git+https://github.com/anufrievroman/waypaper

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------

sudo cp $SCRIPT_DIR/scripts/grimblast /usr/bin

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source $SCRIPT_DIR/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source $SCRIPT_DIR/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source $SCRIPT_DIR/_icons.sh

# --------------------------------------------------------------
# Migrate
# --------------------------------------------------------------

source $SCRIPT_DIR/migrate.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update
