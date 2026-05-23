#!/usr/bin/env bash

# ML4W OS Setup Stable Release
set -e

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

TAG="0.2.5"

# --- UI ---
info() { echo -e "${BLUE}[BOOTSTRAP]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

info "Starting ML4W Dotfiles Setup..."

# 1. Distro Detection by Binary (as requested)
if command -v pacman &> /dev/null; then
    DISTRO="arch"
    info "Arch Linux detected. Installing base dependencies..."
    sudo pacman -S --needed --noconfirm git make curl jq
elif command -v dnf &> /dev/null; then
    DISTRO="fedora"
    info "Fedora detected. Installing base dependencies..."
    sudo dnf install -y git make curl jq
elif command -v zypper &> /dev/null; then
    DISTRO="opensuse"
    info "openSUSE detected. Installing base dependencies..."
    sudo zypper install -y git make curl jq
else
    error "Unsupported distribution. Please install git, make, curl, and jq manually."
fi

# 2. Prepare Temporary Folder
TEMP_DIR=$(mktemp -d -t ml4w-installer-XXXXXX)
info "Cloning ML4W Dotfiles Installer $TAG into $TEMP_DIR..."

# 3. Clone and Install the App
git clone --depth=1 --branch $TAG -c advice.detachedHead=false https://github.com/mylinuxforwork/ml4w-dotfiles-installer.git "$TEMP_DIR"
cd "$TEMP_DIR"

info "Installing ML4W Dotfiles Installer to ~/.local/bin..."
make install

# 4. Ensure ~/.local/bin is in PATH for this session
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    warn "~/.local/bin is not in your PATH. Adding it for this session..."
    export PATH="$HOME/.local/bin:$PATH"

    # Add to .bashrc if not present
    if [[ -f "$HOME/.bashrc" ]] && ! grep -q ".local/bin" "$HOME/.bashrc"; then
        info "Adding ~/.local/bin to your .bashrc for future sessions..."
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
fi

# 5. Execute the Installer
info "Launching the Dotfiles Installer..."
ml4w-dotfiles-installer --install https://raw.githubusercontent.com/corazon008/dotfiles/main/hyprland-dotfiles.dotinst

# Cleanup
rm -rf "$TEMP_DIR"
success "Setup process finished!"
