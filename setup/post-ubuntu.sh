#!/usr/bin/env bash

# --------------------------------------------------------------
# Mask systemd --user units that duplicate autostart.lua's own
# exec-once launching of these daemons. Ubuntu's packaging ships
# "enabled" units for these (WantedBy=graphical-session.target), which
# Hyprland never activates directly, but at least one is triggered by
# other means anyway -- confirmed on the VM: without masking these,
# GDM spams "Failed Units Monitor" alerts. hyprpolkitagent.service is
# intentionally NOT masked here -- it's the intended polkit agent and
# is started explicitly from autostart.lua instead of relying on
# WantedBy=graphical-session.target (which Hyprland never activates).
#
# swaync.service is ALSO intentionally not masked (see below, near
# autostart.lua's former swaync exec-once line, for why) -- it needs
# D-Bus activation to still work so it can restart itself if it dies.
# --------------------------------------------------------------

for _svc in waybar.service hypridle.service hyprsunset.service; do
    if systemctl --user list-unit-files "$_svc" &>/dev/null; then
        systemctl --user mask "$_svc" 2>/dev/null || true
    fi
done

# Undo swaync.service being masked by an earlier version of this script
# (confirmed live: masking it broke D-Bus reactivation permanently --
# every swaync-client call, including waybar's own notification-count
# module, hangs forever trying to auto-activate a masked unit).
systemctl --user unmask swaync.service 2>/dev/null || true

# --------------------------------------------------------------
# snapd-desktop-integration: on GDM-based Ubuntu installs, this snap
# tries to run under every session (including Hyprland) and fails,
# producing a "Failed Units" notification on the GDM greeter. Switching
# to the candidate channel plus a GNOME-only condition drop-in (so it
# still runs normally under GNOME sessions) resolves it. No-op if snap
# isn't installed.
# --------------------------------------------------------------

if command -v snap &> /dev/null && snap list snapd-desktop-integration &> /dev/null; then
    sudo snap refresh snapd-desktop-integration --channel=candidate >> "$LOG_FILE" 2>&1 || true

    systemctl --user mask snapd-desktop-integration 2>/dev/null || true

    _snap_svc="snap.snapd-desktop-integration.snapd-desktop-integration.service"
    mkdir -p "$HOME/.config/systemd/user/${_snap_svc}.d"
    cat > "$HOME/.config/systemd/user/${_snap_svc}.d/gnome-only.conf" <<-EOF
[Unit]
ConditionEnvironment=XDG_CURRENT_DESKTOP=ubuntu:GNOME
EOF

    systemctl --user daemon-reload 2>/dev/null || true
fi

# --------------------------------------------------------------
# mate-polkit: its autostart entry only excludes GNOME and KDE
# (NotShowIn=GNOME;KDE;), so it launches under Hyprland too and fights
# hyprpolkitagent for the polkit authentication agent registration --
# confirmed live, its dialog was the one showing up instead of
# hyprpolkitagent's. Not a systemd unit, so it can't be masked the
# normal way; hiding it via the standard XDG per-user autostart
# override instead. No-op if mate-polkit isn't installed.
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

run_quiet "Installing Oh My Posh" bash -c \
    'curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin'

# --------------------------------------------------------------
# ML4W Settings App
# --------------------------------------------------------------
# The upstream bootstrap script's distro detection only recognizes
# pacman/dnf/zypper and hard-exits on anything else (same shape as the
# top-level ml4w.com/os/rolling bootstrap and ml4w-dotfiles-installer --
# none of them know about apt yet). Download it and patch in an apt
# branch rather than piping curl straight to bash, so this doesn't
# silently fail on Ubuntu.
# --------------------------------------------------------------

ML4W_SETTINGS_SETUP=$(mktemp -t ml4w-settings-setup-XXXXXX.sh)
curl -fsSL https://raw.githubusercontent.com/mylinuxforwork/ml4w-dotfiles-settings/main/setup.sh -o "$ML4W_SETTINGS_SETUP"
sed -i '/^else$/i\
elif command -v apt-get \&> /dev/null; then\
    DISTRO="ubuntu"\
    info "Ubuntu detected. Installing base dependencies..."\
    sudo apt-get install -y git make jq gawk gum' "$ML4W_SETTINGS_SETUP"
run_quiet "Installing ML4W Settings App" bash "$ML4W_SETTINGS_SETUP"
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
    # Checking the actual install target rather than `command -v awww`
    # matters here: `cargo install` writes to the persistent ~/.cargo/bin
    # first, and awww/awww-daemon are built as two separate targets in one
    # `cargo install` call that can succeed independently -- a run where
    # awww built but awww-daemon failed (e.g. before libwayland-dev was
    # added below) leaves ~/.cargo/bin/awww in place, which `command -v`
    # would find on PATH and use to skip this whole block on every
    # subsequent run, permanently preventing /usr/local/bin/awww-daemon
    # from ever being (re)installed. Confirmed live: awww-daemon ran fine
    # (found via ~/.cargo/bin on PATH) while plain `awww` was
    # "command not found" in a shell without ~/.cargo/bin on PATH.
    # common/build.rs probes for liblz4 via pkg-config; daemon/build.rs
    # generates Wayland protocol bindings and needs wayland.xml, which
    # comes from wayland-client's pkgdatadir (libwayland-dev). The
    # extension protocols it also needs (viewporter, fractional-scale)
    # come from wayland-protocols, already guaranteed by hyprland's own
    # apt dependency chain earlier in this script.
    run_quiet "Building awww from source" bash -c '
        set -e
        sudo apt-get install -y liblz4-dev pkg-config libwayland-dev
        cargo install --git https://codeberg.org/LGFae/awww --tag v0.12.1 awww awww-daemon --locked
        sudo cp "$HOME/.cargo/bin/awww" /usr/local/bin/awww
        sudo cp "$HOME/.cargo/bin/awww-daemon" /usr/local/bin/awww-daemon
    '
    info "awww installed to /usr/local/bin"
fi

# Remove hyprpaper -- conflicts with awww, matches the swww-removal
# guard in preflight-ubuntu.sh (same reasoning, different wallpaper
# daemon).
if dpkg -l 2>/dev/null | grep -q "^ii  hyprpaper "; then
    sudo apt-get remove -y hyprpaper >> "$LOG_FILE" 2>&1
fi

# --------------------------------------------------------------
# Quickshell (built from source, not the danklinux PPA's quickshell-git
# package -- pinned to the exact commit that PPA package already builds
# from, since it's the one already validated to work with this repo's
# QML config: 4df562d, which was origin/master HEAD at the time this was
# written). Dependencies verified against BUILD.md and the actual
# find_package()/pkg_check_modules() calls in CMakeLists.txt, not
# assumed -- private Qt headers are only needed pre-Qt-6.10 for
# qt6-wayland (this system has 6.10.2, so that one's skipped), and
# libcpptrace-dev/spirv-tools are already available via the PPAs added
# in preflight-ubuntu.sh. libzstd-dev isn't a quickshell dependency
# directly -- it's cpptrace's crash-handling feature pulling in a
# find_dependency(zstd) that fails the whole cmake configure if it's
# missing. Confirmed live: failed with "Could NOT find zstd" on a clean
# VM where nothing else happened to pull it in already.
# --------------------------------------------------------------

if ! command -v qs &> /dev/null; then
    QS_SRC=$(mktemp -d -t quickshell-src-XXXXXX)
    run_quiet "Building quickshell from source" bash -c '
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
    ' _ "$QS_SRC"
    rm -rf "$QS_SRC"
    info "quickshell installed."
fi

# --------------------------------------------------------------
# nwg-dock-hyprland (no apt package; Go build)
# --------------------------------------------------------------

if ! command -v nwg-dock-hyprland &> /dev/null; then
    NWG_DOCK_SRC=$(mktemp -d -t nwg-dock-XXXXXX)
    run_quiet "Building nwg-dock-hyprland from source" bash -c '
        set -e
        sudo apt-get install -y golang-go libgtk-3-dev libgtk-layer-shell-dev libgtk-4-dev
        git clone --depth=1 --branch v0.4.11 https://github.com/nwg-piotr/nwg-dock-hyprland "$1"
        cd "$1" && make get && make build && sudo make install
    ' _ "$NWG_DOCK_SRC"
    rm -rf "$NWG_DOCK_SRC"
    info "nwg-dock-hyprland installed."
fi

# --------------------------------------------------------------
# Walker (app launcher, Rust) + Elephant (its provider daemon, Go)
# --------------------------------------------------------------

if ! command -v walker &> /dev/null; then
    WALKER_SRC=$(mktemp -d -t walker-XXXXXX)
    run_quiet "Building Walker from source" bash -c '
        set -e
        sudo apt-get install -y protobuf-compiler libgtk-4-dev libgtk4-layer-shell-dev libpoppler-glib-dev libgdk-pixbuf-2.0-dev
        git clone --depth=1 --branch v2.16.2 https://github.com/abenz1267/walker "$1"
        (cd "$1" && cargo build --release)
        sudo cp "$1/target/release/walker" /usr/local/bin/walker
    ' _ "$WALKER_SRC"
    rm -rf "$WALKER_SRC"
    info "Walker installed."
fi

if [ ! -x /usr/local/bin/elephant ]; then
    ELEPHANT_SRC=$(mktemp -d -t elephant-XXXXXX)
    run_quiet "Building Elephant from source" bash -c '
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
    ' _ "$ELEPHANT_SRC"
    rm -rf "$ELEPHANT_SRC"
    info "Elephant and providers installed."
fi

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------
# clean-install-grimblast.sh's Makefile generates a man page from
# grimblast.1.scd via scdoc -- both `make` (default target) and
# `make install` depend on it, so it has to be present before sourcing
# this (shared, unmodified) script.

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
    pipx install pywalfox
    pipx ensurepath
'

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

run_quiet "Installing cursors" bash "$repo_path/setup/_cursors.sh"

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

run_quiet "Installing bundled fonts" bash "$repo_path/setup/_fonts.sh"

# JetBrains Mono Nerd Font -- no Ubuntu package, unlike
# ttf-jetbrains-mono-nerd (Arch)/nerd-fonts-JetBrainsMono (Fedora
# copr)/jetbrainsmono-nerd-fonts (openSUSE repo). Used by
# dotfiles/.config/kitty/kitty.conf's font_family.
JBM_DEST="/usr/share/fonts/JetBrainsMonoNerd"
if [ ! -d "$JBM_DEST" ]; then
    JBM_TMP=$(mktemp -d)
    if run_quiet "Installing JetBrains Mono Nerd Font" bash -c '
        set -e
        curl -fsSL -o "$1/jbm.zip" \
            "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        (cd "$1" && unzip -q jbm.zip -d extracted)
        sudo mkdir -p "$2"
        sudo cp "$1"/extracted/*.ttf "$2/"
    ' _ "$JBM_TMP" "$JBM_DEST"; then
        :
    else
        warn "Failed to download JetBrains Mono Nerd Font; kitty font_family will fall back."
    fi
    rm -rf "$JBM_TMP"
fi

# Font Awesome 7 (Free + Brands) -- waybar's theme CSS font-family
# chains want the "Font Awesome 7 Free"/"Font Awesome 7 Brands" family
# names specifically (falling back to 6, then the ancient FontAwesome
# name). apt's fonts-font-awesome package is really Font Awesome 4.7
# rebadged and only registers the plain "FontAwesome" family, so most
# modern icon glyphs (different PUA codepoints per major version) don't
# resolve through it -- confirmed live via fc-list. Kept the apt
# package too (harmless) and added the real thing on top.
FA_DEST="/usr/share/fonts/font-awesome-7"
if [ ! -d "$FA_DEST" ]; then
    FA_TMP=$(mktemp -d)
    if run_quiet "Installing Font Awesome 7" bash -c '
        set -e
        curl -fsSL -o "$1/fa.zip" \
            "https://github.com/FortAwesome/Font-Awesome/releases/download/7.3.0/fontawesome-free-7.3.0-desktop.zip"
        (cd "$1" && unzip -q fa.zip -d extracted)
        sudo mkdir -p "$2"
        sudo cp "$1"/extracted/*/otfs/*.otf "$2/"
    ' _ "$FA_TMP" "$FA_DEST"; then
        :
    else
        warn "Failed to download Font Awesome 7; waybar icons may not render."
    fi
    rm -rf "$FA_TMP"
fi

sudo fc-cache -f >> "$LOG_FILE" 2>&1

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

run_quiet "Installing icons" bash "$repo_path/setup/_icons.sh"

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update
