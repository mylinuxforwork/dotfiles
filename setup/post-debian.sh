#!/usr/bin/env bash

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# ML4W Settings App
#
# Upstream setup.sh has no Debian branch (pacman/dnf/zypper only),
# so we replicate it here: install deps via apt, clone, make install.
# --------------------------------------------------------------

info "Installing ML4W Dotfiles Settings dependencies (Debian)..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git make jq gawk gum

ML4W_SETTINGS_TMP=$(mktemp -d -t ml4w-dotfiles-settings-XXXXXX)
info "Cloning ML4W Dotfiles Settings into $ML4W_SETTINGS_TMP..."
git clone --depth=1 https://github.com/mylinuxforwork/ml4w-dotfiles-settings.git "$ML4W_SETTINGS_TMP"
make -C "$ML4W_SETTINGS_TMP" install
rm -rf "$ML4W_SETTINGS_TMP"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    if [[ -f "$HOME/.bashrc" ]] && ! grep -q ".local/bin" "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
fi

# --------------------------------------------------------------
# Cargo (matugen, awww)
# --------------------------------------------------------------

MATUGEN_TARGET="4.0.0"

force_install_matugen() {
    info "Running: cargo install matugen --force"
    cargo install matugen --force
}

if ! command -v matugen &> /dev/null; then
    info "matugen is not installed. Installing..."
    force_install_matugen
else
    CURRENT=$(matugen --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    LOWEST=$(printf "%s\n%s" "$MATUGEN_TARGET" "$CURRENT" | sort -V | head -n1)
    if [ "$LOWEST" = "$CURRENT" ] && [ "$CURRENT" != "$MATUGEN_TARGET" ]; then
        info "matugen $CURRENT < $MATUGEN_TARGET, updating..."
        force_install_matugen
    else
        info "matugen $CURRENT is up to date."
    fi
fi

if ! command -v awww &> /dev/null; then
    info "Installing awww + awww-daemon via cargo (codeberg source)..."
    cargo install --git https://codeberg.org/LGFae/awww awww awww-daemon
else
    info "awww already installed."
fi

# --------------------------------------------------------------
# pywalfox via pipx (PEP 668 makes pip install --user unreliable on
# Debian; pipx is the supported path)
# --------------------------------------------------------------

if ! command -v pywalfox &> /dev/null; then
    info "Installing pywalfox via pipx..."
    pipx install pywalfox
    pipx ensurepath
else
    info "pywalfox already installed."
fi

# --------------------------------------------------------------
# Nerd Fonts (FiraCode, JetBrainsMono) — not packaged in Debian.
# Pull from upstream release tarballs.
# --------------------------------------------------------------

NERD_VER="${NERD_FONTS_VERSION:-v3.4.0}"
NERD_TMP=$(mktemp -d)
NERD_DEST="/usr/share/fonts/nerd-fonts"

install_nerd_font() {
    local name=$1
    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VER}/${name}.tar.xz"
    info "  - Downloading ${name} ${NERD_VER}"
    if ! curl -fsSL -o "$NERD_TMP/${name}.tar.xz" "$url"; then
        warn "  - Failed to download ${name}; skipping"
        return 1
    fi
    sudo mkdir -p "$NERD_DEST/${name}"
    sudo tar -xf "$NERD_TMP/${name}.tar.xz" -C "$NERD_DEST/${name}"
}

info "Installing Nerd Fonts (${NERD_VER})..."
install_nerd_font "FiraCode"
install_nerd_font "JetBrainsMono"
sudo fc-cache -f
rm -rf "$NERD_TMP"

# --------------------------------------------------------------
# Font Awesome 7 Free
#
# Debian's `fonts-font-awesome` package is actually FA 4.7 (the
# `5.0.10+really4.7.0` version string is misleading). ML4W's waybar
# modules.json uses codepoints introduced in FA 6/7 — e.g. U+F5FD
# (screwdriver-wrench/Tools), U+E4DC, U+E473 — that exist in
# `Font Awesome 7 Free Solid` and nowhere else in the Nerd Font
# patches we install. Pull FA 7 from upstream so those glyphs render.
# --------------------------------------------------------------

FA_VER="${FONT_AWESOME_VERSION:-7.1.0}"
FA_DEST="/usr/share/fonts/font-awesome-7"
if [ ! -d "$FA_DEST" ]; then
    info "Installing Font Awesome ${FA_VER} Free..."
    FA_TMP=$(mktemp -d)
    if curl -fsSL -o "$FA_TMP/fa.zip" \
        "https://github.com/FortAwesome/Font-Awesome/releases/download/${FA_VER}/fontawesome-free-${FA_VER}-desktop.zip"; then
        (cd "$FA_TMP" && unzip -q fa.zip)
        sudo mkdir -p "$FA_DEST"
        sudo cp "$FA_TMP/fontawesome-free-${FA_VER}-desktop/otfs/"*.otf "$FA_DEST/"
        sudo fc-cache -f
    else
        warn "  - Failed to download Font Awesome ${FA_VER}; waybar icons may not render"
    fi
    rm -rf "$FA_TMP"
else
    info "Font Awesome 7 already installed."
fi

# --------------------------------------------------------------
# Grimblast (vendored script in the dotfiles repo)
# --------------------------------------------------------------

if [ -f "$repo_path/setup/scripts/grimblast" ]; then
    sudo cp "$repo_path/setup/scripts/grimblast" /usr/bin/grimblast
    sudo chmod +x /usr/bin/grimblast
fi

# --------------------------------------------------------------
# Cursors / fonts / icons
# --------------------------------------------------------------

source "$repo_path/setup/_cursors.sh"
source "$repo_path/setup/_fonts.sh"
source "$repo_path/setup/_icons.sh"

# --------------------------------------------------------------
# XDG user dirs
# --------------------------------------------------------------

xdg-user-dirs-update
