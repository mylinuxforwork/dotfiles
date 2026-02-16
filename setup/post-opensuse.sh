#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

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
# Install swww
# --------------------------------------------------------------

sudo zypper addrepo https://download.opensuse.org/repositories/X11:Wayland/openSUSE_Tumbleweed/X11:Wayland.repo
sudo zypper -n install swww

# --------------------------------------------------------------
# JetBrains Mono Nerd Font
# --------------------------------------------------------------

sudo zypper addrepo https://download.opensuse.org/repositories/X11:fonts/openSUSE_Factory/X11:fonts.repo
sudo zypper -n install jetbrainsmono-nerd-fonts

# --------------------------------------------------------------
# Install waypaper dependencies before using pip
# --------------------------------------------------------------

sudo zypper install gcc pkg-config cairo-devel gobject-introspection-devel libgirepository-1_0-1-devel python3-devel libgtk-4-devel typelib-1_0-Gtk-4_0

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
sudo zypper -n install python313-screeninfo
pipx install hyprshade
pipx install pywalfox
pipx install waypaper

# --------------------------------------------------------------
# ML4W Apps
# --------------------------------------------------------------

source $SCRIPT_DIR/_ml4w-apps.sh

# --------------------------------------------------------------
# Flatpaks
# --------------------------------------------------------------

source $SCRIPT_DIR/_flatpaks.sh

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
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update