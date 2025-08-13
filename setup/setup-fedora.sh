#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# Library
# --------------------------------------------------------------

source $SCRIPT_DIR/_lib.sh

# --------------------------------------------------------------
# General Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/pkgs.sh

# --------------------------------------------------------------
# Distro related packages
# --------------------------------------------------------------

packages=(
    # Hyprland
    "hyprland"
    # Tools
    "libnotify"
    "qt5-qtwayland"
    "qt6-qtwayland"
    "uwsm"
    "python-pip"
    "python3-gobject"
    "nm-connection-editor"
    "network-manager-applet"
    "fuse"
    "ImageMagick"
    "NetworkManager-tui"
    # Apps
    "waypaper"
    "SwayNotificationCenter"
    # Themes
    "papirus-icon-theme"
    "papirus-icon-theme-dark"
    "breeze"
    # Fonts
    "dejavu-fonts-all"
    "fontawesome-fonts"
    "noto-fonts"
    "google-noto-emoji-fonts"
    "google-noto-sans-cjk-fonts"
)

_isInstalled() {
    package="$1"
    check=$(dnf list --installed | grep $package)
    if [ -z "$check" ]; then
        echo 1
        return #false
    else
        echo 0
        return #true
    fi
}

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed."
            continue
        fi
        sudo dnf install --assumeyes --skip-unavailable "${pkg}"
    done
}

# --------------------------------------------------------------
# Gum
# --------------------------------------------------------------

if [[ $(_checkCommandExists "gum") == 0 ]]; then
    echo ":: gum is already installed"
else
    echo ":: The installer requires gum. gum will be installed now"
echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo yum install --assumeyes gum
fi

# --------------------------------------------------------------
# Header
# --------------------------------------------------------------

_writeHeader "Fedora"

# --------------------------------------------------------------
# Copr
# --------------------------------------------------------------

sudo dnf copr enable --assumeyes solopasha/hyprland
sudo dnf copr enable --assumeyes peterwu/rendezvous
sudo dnf copr enable --assumeyes wef/cliphist
sudo dnf copr enable --assumeyes tofik/nwg-shell
sudo dnf copr enable --assumeyes erikreider/SwayNotificationCenter

# --------------------------------------------------------------
# General
# --------------------------------------------------------------

_installPackages "${general[@]}"

# --------------------------------------------------------------
# Apps
# --------------------------------------------------------------

_installPackages "${apps[@]}"

# --------------------------------------------------------------
# Tools
# --------------------------------------------------------------

_installPackages "${tools[@]}"

# --------------------------------------------------------------
# Packages
# --------------------------------------------------------------

_installPackages "${packages[@]}"

# --------------------------------------------------------------
# Hyprland
# --------------------------------------------------------------
_installPackages "${hyprland[@]}"

# --------------------------------------------------------------
# Fix xdg-desktop-portal conflicts
# --------------------------------------------------------------
echo ":: Configuring xdg-desktop-portal to use Hyprland as default"
# Create the directory if it doesn't exist
if [ ! -d /etc/xdg/xdg-desktop-portal ]; then
    sudo mkdir -p /etc/xdg/xdg-desktop-portal
fi

# Create the configuration file to prioritize Hyprland
echo "[main]" | sudo tee /etc/xdg/xdg-desktop-portal/hyprland-portal.conf
echo "default=hyprland" | sudo tee -a /etc/xdg/xdg-desktop-portal/hyprland-portal.conf

# --------------------------------------------------------------
# Create .local/bin folder
# --------------------------------------------------------------

if [ ! -d $HOME/.local/bin ]; then
    mkdir -p $HOME/.local/bin
fi

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# Prebuild Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/_prebuilt.sh

echo "Installing eza v0.23.0"
# https://github.com/eza-community/eza/releases
sudo cp $SCRIPT_DIR/packages/eza /usr/bin

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
sudo pip install hyprshade
sudo pip install pywalfox
sudo pywalfox install
sudo pip install screeninfo
sudo pip install waypaper

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
# Finish
# --------------------------------------------------------------

_finishMessage
