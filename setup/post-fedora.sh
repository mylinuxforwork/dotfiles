#!/usr/bin/env bash

# --------------------------------------------------------------
# nwg-displays
# --------------------------------------------------------------

if rpm -q nwg-displays &>/dev/null; then
    info "Old nwg-displays system package detected. Removing to prevent conflicts..."
    sudo dnf remove -y nwg-displays
fi
info "Building and deploying latest nwg-displays..."
NWG_DISPLAYS_BUILD_DIR=$(mktemp -d)
git clone https://github.com/nwg-piotr/nwg-displays.git "$NWG_DISPLAYS_BUILD_DIR"
python3 -m pip install --user --break-system-packages "$NWG_DISPLAYS_BUILD_DIR"
info "nwg-displays installed to ~/.local/bin/"
rm -rf $NWG_DISPLAYS_BUILD_DIR

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
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
sudo pip install pywalfox

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
