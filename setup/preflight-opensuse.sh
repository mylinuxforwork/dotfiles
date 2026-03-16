#!/usr/bin/env bash

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# Prebuild Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/_prebuilt.sh

# --------------------------------------------------------------
# Repositories
# --------------------------------------------------------------

sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Tumbleweed/home:AvengeMedia:danklinux.repo
sudo zypper ar https://download.opensuse.org/tumbleweed/repo/oss/ factory-oss
sudo zypper addrepo https://download.opensuse.org/repositories/X11:Wayland/openSUSE_Tumbleweed/X11:Wayland.repo
sudo zypper addrepo https://download.opensuse.org/repositories/X11:fonts/openSUSE_Factory/X11:fonts.repo

# --------------------------------------------------------------
# Install waypaper dependencies before using pip
# --------------------------------------------------------------

sudo zypper install gcc pkg-config cairo-devel gobject-introspection-devel libgirepository-1_0-1-devel python3-devel libgtk-4-devel typelib-1_0-Gtk-4_0

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
sudo zypper -n install python313-screeninfo
pipx install pywalfox
pipx install waypaper