#!/usr/bin/env bash

set -euo pipefail

# --------------------------------------------------------------
# Mask systemd --user units that duplicate autostart.lua's own
# exec-once daemons -- Ubuntu ships them "enabled" and something
# triggers at least one anyway, spamming GDM's Failed Units Monitor.
# hyprpolkitagent.service and swaync.service stay unmasked:
# hyprpolkitagent is started explicitly below instead, and swaync
# needs D-Bus activation working to restart itself if it dies.
# --------------------------------------------------------------

for _svc in waybar.service hypridle.service hyprsunset.service; do
    if systemctl --user list-unit-files "$_svc" &>/dev/null; then
        systemctl --user mask "$_svc" 2>/dev/null || true
    fi
done

# Undo an earlier version of this script masking swaync.service --
# that broke D-Bus reactivation permanently (swaync-client calls,
# including waybar's own notification-count module, hung forever).
systemctl --user unmask swaync.service 2>/dev/null || true

# --------------------------------------------------------------
# snapd-desktop-integration: tries to run under every session on
# GDM-based installs and fails, spamming a "Failed Units" notification
# on the greeter. Candidate channel + GNOME-only condition drop-in
# fixes it without breaking GNOME. No-op if snap isn't installed.
# --------------------------------------------------------------

if command -v snap &> /dev/null && snap list snapd-desktop-integration &> /dev/null; then
    sudo snap refresh snapd-desktop-integration --channel=candidate >> "$LOG_FILE" 2>&1 || true

    # Gated via ConditionEnvironment, not masked, so it still runs
    # under real GNOME sessions. Assumes XDG_CURRENT_DESKTOP reaches
    # the systemd --user manager's env (gnome-session imports it at
    # session start) -- not independently verified here.
    _snap_svc="snap.snapd-desktop-integration.snapd-desktop-integration.service"
    mkdir -p "$HOME/.config/systemd/user/${_snap_svc}.d"
    cat > "$HOME/.config/systemd/user/${_snap_svc}.d/gnome-only.conf" <<-EOF
[Unit]
ConditionEnvironment=XDG_CURRENT_DESKTOP=ubuntu:GNOME
EOF

    systemctl --user daemon-reload 2>/dev/null || true
fi

# --------------------------------------------------------------
# mate-polkit's autostart entry only excludes GNOME/KDE, so it
# launches under Hyprland too and wins the polkit-agent race over
# hyprpolkitagent. Not a systemd unit, so hide it via the standard
# XDG per-user autostart override instead. No-op if not installed.
# --------------------------------------------------------------

if [ -f /etc/xdg/autostart/polkit-mate-authentication-agent-1.desktop ]; then
    mkdir -p "$HOME/.config/autostart"
    cat > "$HOME/.config/autostart/polkit-mate-authentication-agent-1.desktop" <<-'EOF'
	[Desktop Entry]
	Hidden=true
	EOF
fi

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

run_quiet "Installing Oh My Posh" bash -c '
    set -euo pipefail
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
'

# --------------------------------------------------------------
# ML4W Settings App
# --------------------------------------------------------------
# Upstream's distro detection only knows pacman/dnf/zypper and
# hard-exits otherwise. Download and patch in an apt branch instead
# of piping curl straight to bash.
# --------------------------------------------------------------

ML4W_SETTINGS_SETUP=$(mktemp -t ml4w-settings-setup-XXXXXX.sh)
curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://raw.githubusercontent.com/mylinuxforwork/ml4w-dotfiles-settings/main/setup.sh -o "$ML4W_SETTINGS_SETUP"

# sed's exit status doesn't reflect whether it matched anything, so
# check the anchor and the patch result explicitly instead of trusting it.
else_count=$(grep -c '^else$' "$ML4W_SETTINGS_SETUP" || true)
if [ "$else_count" -ne 1 ]; then
    error "ml4w-dotfiles-settings setup.sh no longer has exactly one"
    error "top-level 'else' (found $else_count) -- skipping ML4W Settings App install."
else
    sed -i '/^else$/i\
elif command -v apt-get \&> /dev/null; then\
    DISTRO="ubuntu"\
    info "Ubuntu detected. Installing base dependencies..."\
    sudo apt-get install -y git make jq gawk gum' "$ML4W_SETTINGS_SETUP"
    if grep -q 'DISTRO="ubuntu"' "$ML4W_SETTINGS_SETUP"; then
        run_quiet "Installing ML4W Settings App" bash "$ML4W_SETTINGS_SETUP"
    else
        error "Failed to patch ml4w-dotfiles-settings setup.sh for Ubuntu -- skipping install."
    fi
fi
rm -f "$ML4W_SETTINGS_SETUP"

# --------------------------------------------------------------
# Cargo -- matugen
# --------------------------------------------------------------

TARGET_VERSION="4.0.0"

force_install_matugen() {
    run_quiet "Installing matugen" cargo install matugen --force
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
    # Checks the actual install target, not `command -v awww` -- cargo
    # install writes to ~/.cargo/bin first, and if awww-daemon's build
    # failed on a previous run, `command -v` would still find the old
    # ~/.cargo/bin/awww and skip this block forever, never retrying
    # awww-daemon.
    run_quiet "Building awww from source" bash -c '
        set -e
        sudo apt-get install -y liblz4-dev pkg-config libwayland-dev
        cargo install --git https://codeberg.org/LGFae/awww --tag v0.12.1 awww awww-daemon --locked
        sudo cp "$HOME/.cargo/bin/awww" /usr/local/bin/awww
        sudo cp "$HOME/.cargo/bin/awww-daemon" /usr/local/bin/awww-daemon
    '
    info "awww installed to /usr/local/bin"
fi

# Remove hyprpaper -- conflicts with awww (same reasoning as the
# swww-removal guard in preflight-ubuntu.sh).
if dpkg -l 2>/dev/null | grep -q "^ii  hyprpaper "; then
    sudo apt-get remove -y hyprpaper >> "$LOG_FILE" 2>&1
fi

# --------------------------------------------------------------
# Shared scaffold for the from-source builds below: stage into a temp
# dir (passed to the build script as $1), run under run_quiet, clean up.
# --------------------------------------------------------------

build_from_source() {
    local label=$1 tmp_prefix=$2 script=$3
    local src_dir status
    src_dir=$(mktemp -d -t "${tmp_prefix}-XXXXXX")
    if run_quiet "Building $label from source" bash -c "$script" _ "$src_dir"; then
        status=0
    else
        status=$?
    fi
    rm -rf "$src_dir"
    return $status
}

# --------------------------------------------------------------
# Built from source (not the danklinux PPA's quickshell-git package),
# pinned to a commit already validated against this repo's QML config.
# libzstd-dev isn't a direct quickshell dep -- it's cpptrace's
# crash-handling feature pulling in zstd, and cmake configure fails
# without it.
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
# Quickshell Overview + ML4W Dock -- pulled in directly, not via
# sourcing setup/post.sh, since its Oh My Posh/ML4W Settings App steps
# are the unpatched originals already fixed above. Placed after the
# quickshell build since ml4w-dock wants qs on PATH.
# --------------------------------------------------------------

# matugen's [templates.quickshell_overview] writes
# common/Appearance.colors.qml into this same path -- if it runs
# first, the installer finds a non-git directory and refuses. Only
# clear it when that specific generated file is present and there's
# no .git, so unrelated user content at this path is never touched.
QSO_DIR="$HOME/.local/share/quickshell-overview"
if [ -f "$QSO_DIR/common/Appearance.colors.qml" ] && [ ! -d "$QSO_DIR/.git" ]; then
    rm -rf "$QSO_DIR"
fi
run_quiet "Installing Quickshell Overview" bash -c '
    set -euo pipefail
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://raw.githubusercontent.com/mylinuxforwork/ml4w-quickshell-overview/main/install.sh | bash
'

run_quiet "Installing ML4W Dock" bash -c '
    set -euo pipefail
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://raw.githubusercontent.com/mylinuxforwork/ml4w-dock/main/install.sh | bash
'

# --------------------------------------------------------------
# Walker (app launcher, Rust) + Elephant (its provider daemon, Go)
# --------------------------------------------------------------

if ! command -v walker &> /dev/null; then
    build_from_source "Walker" walker '
        set -e
        sudo apt-get install -y protobuf-compiler libgtk-4-dev libgtk4-layer-shell-dev libpoppler-glib-dev libgdk-pixbuf-2.0-dev
        git clone --depth=1 --branch v2.16.2 https://github.com/abenz1267/walker "$1"
        (cd "$1" && cargo build --release)
        sudo cp "$1/target/release/walker" /usr/local/bin/walker
    '
    info "Walker installed."
fi

if [ ! -x /usr/local/bin/elephant ]; then
    build_from_source "Elephant" elephant '
        set -e
        sudo apt-get install -y golang-go
        git clone --depth=1 --branch v2.21.0 https://github.com/abenz1267/elephant "$1"
        (cd "$1/cmd/elephant" && go build -o "$HOME/go/bin/elephant" .)
        sudo cp "$HOME/go/bin/elephant" /usr/local/bin/elephant
        mkdir -p "$HOME/.config/elephant/providers"
        for _pdir in "$1/internal/providers"/*/; do
            _provider=$(basename "$_pdir")
            (cd "$_pdir" && go build -buildmode=plugin -o "$HOME/.config/elephant/providers/${_provider}.so" .) || true
        done
    '
    info "Elephant and providers installed."
fi

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------
# clean-install-grimblast.sh's Makefile needs scdoc to build its man
# page (both `make` and `make install` depend on it).

run_quiet "Installing grimblast" bash -c '
    set -e
    sudo apt-get install -y scdoc
    bash "$1"
' _ "$repo_path/setup/clean-install-grimblast.sh"

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

run_quiet "Installing pywalfox" bash -c '
    set -e
    sudo apt-get install -y python3-pip pipx
    pipx install pywalfox || pipx upgrade pywalfox
    pipx ensurepath
'

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

# Shared scaffold for the zip fonts below -- only creates $dest once
# files are confirmed extracted, so a failed download can't leave an
# empty $dest that fools the caller's `[ ! -d "$dest" ]` guard.
install_font_zip() {
    local label=$1 url=$2 glob=$3 dest=$4
    local tmp
    tmp=$(mktemp -d)
    if run_quiet "Installing $label" bash -c '
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

# JetBrains Mono Nerd Font -- no Ubuntu package (unlike Arch/Fedora/
# openSUSE). Used by kitty.conf's font_family.
JBM_DEST="/usr/share/fonts/JetBrainsMonoNerd"
if [ ! -d "$JBM_DEST" ]; then
    install_font_zip "JetBrains Mono Nerd Font" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
        "*.ttf" "$JBM_DEST" ||
        warn "Failed to download JetBrains Mono Nerd Font; kitty font_family will fall back."
fi

# Font Awesome 7 -- apt's fonts-font-awesome is really 4.7 rebadged
# and only registers "FontAwesome", not the "Font Awesome 7
# Free/Brands" families waybar's CSS wants. Kept the apt package too
# (harmless).
FA_DEST="/usr/share/fonts/font-awesome-7"
if [ ! -d "$FA_DEST" ]; then
    install_font_zip "Font Awesome 7" \
        "https://github.com/FortAwesome/Font-Awesome/releases/download/7.3.0/fontawesome-free-7.3.0-desktop.zip" \
        "*/otfs/*.otf" "$FA_DEST" ||
        warn "Failed to install Font Awesome 7; waybar icons may not render."
fi

sudo fc-cache -f >> "$LOG_FILE" 2>&1
