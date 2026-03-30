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
# Installation of waypaper-git
# --------------------------------------------------------------

if pacman -Qq waypaper-git &> /dev/null; then
    info "waypaper-git is already installed. Doing nothing."
else
    if pacman -Qq waypaper &> /dev/null; then
        info "Standard 'waypaper' is currently installed. Uninstalling..."
        $aur_helper -Rns --noconfirm waypaper
    else
        info "Standard 'waypaper' is not installed."
    fi
    info "Installing 'waypaper-git'..."
    $aur_helper -S --noconfirm waypaper-git
fi

# --------------------------------------------------------------
# Cargo
# --------------------------------------------------------------

cargo install cargo-update

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

