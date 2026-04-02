#!/usr/bin/env bash

# --------------------------------------------------------------
# awww
# --------------------------------------------------------------

sudo zypper --non-interactive --gpg-auto-import-keys install awww

# --------------------------------------------------------------
# Quickshell
# --------------------------------------------------------------

# Add DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Tumbleweed/home:AvengeMedia:danklinux.repo
sudo zypper refresh
sudo zypper install quickshell

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# ML4W Settings App
# --------------------------------------------------------------

bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/ml4w-dotfiles-settings/main/setup.sh)

# --------------------------------------------------------------
# Cargo
# --------------------------------------------------------------

TARGET_VERSION="4.0.0"

force_install_matugen() {
    info "Running: cargo install matugen --force"
    cargo install matugen --force
}

if ! command -v matugen &> /dev/null; then
    echo "'matugen' is not currently installed."
    force_install_matugen
else
    CURRENT_VERSION=$(matugen --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    LOWEST_VERSION=$(printf "%s\n%s" "$TARGET_VERSION" "$CURRENT_VERSION" | sort -V | head -n1)
    if [ "$LOWEST_VERSION" = "$CURRENT_VERSION" ] && [ "$CURRENT_VERSION" != "$TARGET_VERSION" ]; then
        info "Current version ($CURRENT_VERSION) is lower than $TARGET_VERSION. Updating..."
        force_install_matugen
    else
        info "matugen is already up to date! (Current version: $CURRENT_VERSION)"
    fi
fi

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
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
pipx install pywalfox

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
