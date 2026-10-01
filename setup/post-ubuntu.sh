#!/usr/bin/env bash

# --------------------------------------------------------------
# Mask systemd --user units that duplicate autostart.lua's exec-once
# daemons. hyprpolkitagent.service and swaync.service stay unmasked --
# hyprpolkitagent is started explicitly below, swaync needs D-Bus
# activation to restart itself if it dies.
# --------------------------------------------------------------

for _svc in waybar.service hypridle.service hyprsunset.service; do
    if systemctl --user list-unit-files "$_svc" &>/dev/null; then
        systemctl --user mask "$_svc" 2>/dev/null || true
    fi
done

systemctl --user unmask swaync.service 2>/dev/null || true
# Marker for autostart.lua: skip the direct swaync launch there and
# rely on D-Bus activation instead (avoids a race between the two).
mkdir -p "$HOME/.config/ml4w"
touch "$HOME/.config/ml4w/.swaync-dbus-activated"

# hyprpolkitagent.service is WantedBy=graphical-session.target, which a
# real GNOME session also activates -- it then collides with GNOME's
# own polkit agent and crashes. Gate it to Hyprland via
# ConditionEnvironment instead of masking, so the explicit start below
# still works.
mkdir -p "$HOME/.config/systemd/user/hyprpolkitagent.service.d"
cat > "$HOME/.config/systemd/user/hyprpolkitagent.service.d/hyprland-only.conf" <<-EOF
[Unit]
ConditionEnvironment=XDG_CURRENT_DESKTOP=Hyprland
EOF
systemctl --user daemon-reload 2>/dev/null || true

# --------------------------------------------------------------
# snapd-desktop-integration: fails under every non-GNOME session on
# GDM installs, spamming Failed Units. Gate via ConditionEnvironment
# rather than masking, so it still runs under real GNOME sessions.
# --------------------------------------------------------------

if command -v snap &> /dev/null && snap list snapd-desktop-integration &> /dev/null; then
    sudo snap refresh snapd-desktop-integration --channel=candidate || true

    _snap_svc="snap.snapd-desktop-integration.snapd-desktop-integration.service"
    mkdir -p "$HOME/.config/systemd/user/${_snap_svc}.d"
    cat > "$HOME/.config/systemd/user/${_snap_svc}.d/gnome-only.conf" <<-EOF
[Unit]
ConditionEnvironment=XDG_CURRENT_DESKTOP=ubuntu:GNOME
EOF

    systemctl --user daemon-reload 2>/dev/null || true
fi

# --------------------------------------------------------------
# mate-polkit fights hyprpolkitagent for the polkit-agent race. Not a
# systemd unit, so hide it via the standard XDG autostart override.
# --------------------------------------------------------------

if [ -f /etc/xdg/autostart/polkit-mate-authentication-agent-1.desktop ]; then
    mkdir -p "$HOME/.config/autostart"
    cat > "$HOME/.config/autostart/polkit-mate-authentication-agent-1.desktop" <<-'EOF'
	[Desktop Entry]
	Hidden=true
	EOF
fi

# --------------------------------------------------------------
# Matugen
# --------------------------------------------------------------

TARGET_VERSION="4.0.0"

force_install_matugen() {
    info "Installing matugen"
    cargo install matugen --force
    info "matugen installed."
}

if ! command -v matugen &> /dev/null; then
    info "'matugen' is not currently installed."
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
# awww (Wayland wallpaper daemon -- replaces swww; no apt/PPA source)
# --------------------------------------------------------------

if [ ! -x /usr/local/bin/awww ] || [ ! -x /usr/local/bin/awww-daemon ]; then
    # Check the install target, not `command -v awww` -- a prior run
    # where only awww-daemon failed to build would otherwise skip this
    # block forever.
    info "Building awww from source"
    bash -c '
        set -e
        sudo apt-get install -y liblz4-dev pkg-config libwayland-dev
        cargo install --git https://codeberg.org/LGFae/awww --tag v0.12.1 awww awww-daemon --locked
        sudo cp "$HOME/.cargo/bin/awww" /usr/local/bin/awww
        sudo cp "$HOME/.cargo/bin/awww-daemon" /usr/local/bin/awww-daemon
    '
    info "awww installed to /usr/local/bin"
fi

if dpkg -l 2>/dev/null | grep -q "^ii  hyprpaper "; then
    sudo apt-get remove -y hyprpaper
fi

# --------------------------------------------------------------
# Shared scaffold for the from-source builds below.
# --------------------------------------------------------------

build_from_source() {
    local label=$1 tmp_prefix=$2 script=$3
    local src_dir status
    src_dir=$(mktemp -d -t "${tmp_prefix}-XXXXXX")
    info "Building $label from source"
    if bash -c "$script" _ "$src_dir"; then
        status=0
    else
        status=$?
    fi
    rm -rf "$src_dir"
    return $status
}

# --------------------------------------------------------------
# Quickshell -- built from source, pinned to a commit already
# validated against this repo's QML config.
# --------------------------------------------------------------

if ! command -v qs &> /dev/null; then
    build_from_source "quickshell" quickshell-src '
        set -e
        sudo apt-get install -y \
            cmake ninja-build pkg-config \
            qt6-base-dev qt6-base-private-dev \
            qt6-declarative-dev qt6-declarative-private-dev \
            qt6-svg-dev qt6-shadertools-dev \
            libcli11-dev \
            libxcb1-dev \
            libdrm-dev libgbm-dev libegl1-mesa-dev \
            libcpptrace-dev libunwind-dev libzstd-dev \
            libwayland-bin libwayland-dev wayland-protocols \
            libglib2.0-dev \
            libpipewire-0.3-dev \
            libjemalloc-dev \
            libvulkan-dev \
            libpolkit-agent-1-dev libpolkit-gobject-1-dev \
            libpam0g-dev \
            spirv-tools
        git clone https://github.com/quickshell-mirror/quickshell "$1"
        (cd "$1" && git checkout -q 4df562dfb2475a9057f0f33a8db75808efad8670)
        cmake -S "$1" -B "$1/build" -GNinja \
            -DCMAKE_BUILD_TYPE=Release \
            -DDISTRIBUTOR="ML4W Ubuntu Support (source build)"
        cmake --build "$1/build"
        sudo cmake --install "$1/build"
    '
    info "quickshell installed."
fi

# --------------------------------------------------------------
# Quickshell Overview + ML4W Dock (placed after quickshell since
# ml4w-dock wants qs on PATH).
# --------------------------------------------------------------

# matugen's [templates.quickshell_overview] writes into this same
# path; clear it only when its output file is present and there's no
# .git, so unrelated content is never touched.
QSO_DIR="$HOME/.local/share/quickshell-overview"
if [ -f "$QSO_DIR/common/Appearance.colors.qml" ] && [ ! -d "$QSO_DIR/.git" ]; then
    rm -rf "$QSO_DIR"
fi
info "Installing Quickshell Overview"
bash -c '
    set -euo pipefail
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://raw.githubusercontent.com/mylinuxforwork/ml4w-quickshell-overview/main/install.sh | bash
'

info "Installing ML4W Dock"
bash -c '
    set -euo pipefail
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://raw.githubusercontent.com/mylinuxforwork/ml4w-dock/main/install.sh | bash
'

# --------------------------------------------------------------
# ML4W Dotfiles Settings App -- its setup.sh only detects pacman/dnf/
# zypper and exits 1 on Ubuntu; post.sh runs it later and tolerates
# that failure, which otherwise leaves ml4w-autostart's
# ~/.local/share/ml4w-dotfiles-settings/quickshell unwritten and the
# `ml4w-settings` alias permanently reporting no running instance.
# Install it ourselves the same way setup.sh does: clone + make install.
# --------------------------------------------------------------

build_from_source "ML4W Dotfiles Settings" ml4w-dotfiles-settings '
    set -e
    git clone --depth=1 https://github.com/mylinuxforwork/ml4w-dotfiles-settings.git "$1"
    make -C "$1" install
'
info "ML4W Dotfiles Settings installed to ~/.local/bin/"

# --------------------------------------------------------------
# nwg-displays -- built from source, not the apt package, for Wayland
# compatibility (matches Fedora/openSUSE).
# --------------------------------------------------------------

if dpkg -l 2>/dev/null | grep -q "^ii  nwg-displays "; then
    sudo apt-get remove -y nwg-displays
fi
# gir1.2-gtklayershell-0.1 is required for nwg-displays to run as an
# overlay via GtkLayerShell; without it, it falls back to a plain
# floating window that Hyprland doesn't position as an overlay.
build_from_source "nwg-displays" nwg-displays '
    set -e
    sudo apt-get install -y python3-pip gir1.2-gtklayershell-0.1
    git clone https://github.com/nwg-piotr/nwg-displays.git "$1"
    python3 -m pip install --user --break-system-packages "$1"
'
info "nwg-displays installed to ~/.local/bin/"

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------

info "Installing grimblast"
bash -c '
    set -e
    sudo apt-get install -y scdoc
    bash "$1"
' _ "$repo_path/setup/clean-install-grimblast.sh"

# --------------------------------------------------------------
# grim -- built from source because Ubuntu's package is compiled
# without JPEG support, which breaks the default .jpg screenshot
# filename. Installs to /usr/local/bin, ahead of the apt grim on PATH.
# --------------------------------------------------------------

if ! ldd /usr/local/bin/grim 2>/dev/null | grep -q libjpeg; then
    build_from_source "grim" grim-src '
        set -e
        sudo apt-get install -y \
            meson ninja-build pkg-config scdoc \
            libpng-dev libjpeg-dev libpixman-1-dev \
            libwayland-bin libwayland-dev wayland-protocols
        git clone --depth=1 --branch v1.5.0 https://gitlab.freedesktop.org/emersion/grim.git "$1"
        meson setup "$1/build" "$1" --buildtype=release -Djpeg=enabled
        ninja -C "$1/build"
        sudo ninja -C "$1/build" install
    '
    info "grim installed to /usr/local/bin"
fi

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

info "Installing pywalfox"
bash -c '
    set -e
    sudo apt-get install -y python3-pip pipx
    pipx install pywalfox || pipx upgrade pywalfox
    pipx ensurepath
'

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

# Only creates $dest once files are confirmed extracted, so a failed
# download can't permanently block retry.
install_font_zip() {
    local label=$1 url=$2 glob=$3 dest=$4
    local tmp
    tmp=$(mktemp -d)
    info "Installing $label"
    if bash -c '
        set -e
        curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors -o "$1/font.zip" "$2"
        (cd "$1" && unzip -q font.zip -d extracted)
        shopt -s nullglob
        files=("$1"/extracted/$4)
        [ ${#files[@]} -gt 0 ]
        sudo mkdir -p "$3"
        sudo cp "${files[@]}" "$3/"
    ' _ "$tmp" "$url" "$dest" "$glob"; then
        rm -rf "$tmp"
        return 0
    fi
    rm -rf "$tmp"
    return 1
}

# JetBrains Mono Nerd Font -- no Ubuntu package.
JBM_DEST="/usr/share/fonts/JetBrainsMonoNerd"
if [ ! -d "$JBM_DEST" ]; then
    install_font_zip "JetBrains Mono Nerd Font" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
        "*.ttf" "$JBM_DEST" ||
        warn "Failed to download JetBrains Mono Nerd Font; kitty font_family will fall back."
fi

# Font Awesome 7 -- apt's fonts-font-awesome is 4.7 rebadged and
# doesn't register the "Font Awesome 7" family waybar's CSS wants.
FA_DEST="/usr/share/fonts/font-awesome-7"
if [ ! -d "$FA_DEST" ]; then
    install_font_zip "Font Awesome 7" \
        "https://github.com/FortAwesome/Font-Awesome/releases/download/7.3.0/fontawesome-free-7.3.0-desktop.zip" \
        "*/otfs/*.otf" "$FA_DEST" ||
        warn "Failed to install Font Awesome 7; waybar icons may not render."
fi

sudo fc-cache -f
