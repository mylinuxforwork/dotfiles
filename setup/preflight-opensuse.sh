#!/usr/bin/env bash

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# Prebuild Packages
# --------------------------------------------------------------

source $repo_path/setup/_prebuilt.sh

# --------------------------------------------------------------
# Repositories
# --------------------------------------------------------------

sudo zypper addrepo https://download.opensuse.org/tumbleweed/repo/oss/ factory-oss
sudo zypper addrepo https://download.opensuse.org/repositories/X11:Wayland/openSUSE_Tumbleweed/X11:Wayland.repo
sudo zypper addrepo https://download.opensuse.org/repositories/X11:fonts/openSUSE_Factory/X11:fonts.repo
sudo zypper addrepo https://download.opensuse.org/repositories/home:/Alxhr0/openSUSE_Tumbleweed/ home_Alxhr0
sudo zypper refresh

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if command -v swww &> /dev/null || rpm -q swww &> /dev/null; then
    sudo zypper remove -y swww
fi