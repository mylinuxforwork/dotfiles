#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup/tmp/arch-install-swww.sh)

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure gum is installed
if ! command -v gum &> /dev/null; then
    echo "==> Error: 'gum' is not installed. Please install it first:"
    echo "    sudo pacman -S gum"
    exit 1
fi

# Display a styled note about the compilation time
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 60 --margin "1 2" --padding "1 2" \
    "swww v0.11.2 Downgrade / Installation" \
    "" \
    "This script will download and compile swww from source." \
    "Please note that compiling Rust binaries can take" \
    "several minutes depending on your CPU."

# Prompt for confirmation
if ! gum confirm "Do you want to proceed with the installation?"; then
    echo "==> Installation aborted by user."
    exit 0
fi

echo "==> Preparing to build and install swww v0.11.2..."

# Ensure the user has base-devel installed, which is required for makepkg
if ! pacman -Qi base-devel > /dev/null 2>&1; then
    echo "==> Warning: 'base-devel' is missing. Please install it first:"
    echo "    sudo pacman -S --needed base-devel"
    exit 1
fi

# 1. Create a clean, temporary build directory
BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

# 2. Generate the PKGBUILD dynamically
echo "==> Generating PKGBUILD for v0.11.2..."
cat << 'EOF' > PKGBUILD
pkgname=swww
pkgver=0.11.2
pkgrel=1
pkgdesc="A Solution to your Wayland Wallpaper Woes (Pre-awww rename)"
arch=('x86_64' 'aarch64')
url="https://github.com/LGFae/swww"
license=('GPL3')
depends=('lz4' 'gcc-libs' 'glibc')
makedepends=('cargo' 'wayland' 'wayland-protocols')
source=("https://github.com/LGFae/swww/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
  cd "$pkgname-$pkgver"
  export CARGO_HOME="$srcdir/cargo-home"
  cargo build --release --locked
}

package() {
  cd "$pkgname-$pkgver"
  install -Dm755 target/release/swww "$pkgdir/usr/bin/swww"
  install -Dm755 target/release/swww-daemon "$pkgdir/usr/bin/swww-daemon"
}
EOF

# 3. Build and install via makepkg/pacman
echo "==> Compiling source and installing..."
makepkg -si --noconfirm

# 4. Clean up the temporary workspace
echo "==> Cleaning up temporary files..."
cd ~
rm -rf "$BUILD_DIR"

echo "==> Success! swww v0.11.2 has been restored." 
echo "==> Please execute waypaper (or SUPER+CTRL+Return and select waypaper) and select swww as wallpaper engine again."
echo "==> Skip the replacement of swww with awww for now during system updates."