#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# Test for AUR helper
# --------------------------------------------------------------

if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo "Error: Neither 'yay' nor 'paru' is installed. Please install one and try again."
    exit 1
fi
echo ":: Using AUR helper: $AUR_HELPER"

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
# Installation of waypaper-git
# --------------------------------------------------------------

if pacman -Qq waypaper-git &> /dev/null; then
    echo ":: waypaper-git is already installed. Doing nothing."
    exit 0
else
    if pacman -Qq waypaper &> /dev/null; then
        echo ":: Standard 'waypaper' is currently installed. Uninstalling..."
        $AUR_HELPER -Rns --noconfirm waypaper
    else
        echo ":: Standard 'waypaper' is not installed."
    fi
    echo ":: Installing 'waypaper-git'..."
    $AUR_HELPER -S --noconfirm waypaper-git
fi

# --------------------------------------------------------------
# Prebuilt Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/_prebuilt.sh

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

