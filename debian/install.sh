#!/usr/bin/env bash
# myml4w orchestrator — installs ML4W Hyprland on Debian forky.
#
# Flow:
#   1. Verify Debian (warn if not forky).
#   2. Bootstrap minimal host deps (git, curl, make, sudo).
#   3. apt install build deps + fpm on the host (`make build-deps`).
#   4. Build .deb packages for software not in Debian (hyprsunset,
#      swaync, nwg-dock-hyprland) into dist/ — built natively on host.
#   5. apt install the built .debs (apt resolves their runtime deps).
#   6. Install the thywyn/ml4w-dotfiles-installer fork.
#   7. Run the installer against profile.dotinst → installs apt deps,
#      runs post-debian.sh (cargo, pipx, Nerd Fonts, etc.), symlinks
#      the dotfiles.
#
# Podman is NOT used here. It's only for opt-in test builds via
# `make build-debs-podman`.

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_REPO="${INSTALLER_REPO:-https://github.com/thywyn/ml4w-dotfiles-installer.git}"
#INSTALLER_DIR="${INSTALLER_DIR:-$HOME/.local/share/myml4w/ml4w-dotfiles-installer}"
INSTALLER_DIR="${INSTALLER_DIR:-$HOME/ml4w-dotfiles-installer}"
PROFILE="${PROFILE:-$ROOT/profile.dotinst}"

INSTALLER_ONLY=false
SKIP_BUILD=false
for arg in "$@"; do
    case "$arg" in
        --installer-only) INSTALLER_ONLY=true ;;
        --skip-build) SKIP_BUILD=true ;;
        -h|--help)
            sed -n '2,21p' "$0"
            exit 0
            ;;
        *) echo "unknown arg: $arg" >&2; exit 1 ;;
    esac
done

info()  { printf '\033[1;32m::\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

# --- 1. Verify Debian ---
if ! command -v apt-get >/dev/null 2>&1; then
    die "apt-get not found — this orchestrator targets Debian forky."
fi
if [ -r /etc/os-release ]; then
    . /etc/os-release
    case "${VERSION_CODENAME:-}" in
        forky) info "Detected Debian forky." ;;
        *) warn "Detected ${PRETTY_NAME:-unknown}; this is tested on forky only." ;;
    esac
fi

# --- 2. Bootstrap host deps ---
need_pkgs=()
for cmd in git curl make sudo; do
    command -v "$cmd" >/dev/null 2>&1 || need_pkgs+=("$cmd")
done
if [ ${#need_pkgs[@]} -gt 0 ]; then
    info "Installing host bootstrap deps: ${need_pkgs[*]}"
    sudo DEBIAN_FRONTEND=noninteractive apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${need_pkgs[@]}"
fi

# --- 3 + 4. Install build deps + build .debs on host ---
if [ "$INSTALLER_ONLY" = false ] && [ "$SKIP_BUILD" = false ]; then
    info "Installing build deps (apt + fpm)..."
    make -C "$ROOT" build-deps
    info "Building .deb packages (this may take a while)..."
    make -C "$ROOT" build-debs
fi

# --- 5. Install built .debs ---
if [ "$INSTALLER_ONLY" = false ]; then
    info "Installing built .debs..."
    make -C "$ROOT" install-debs
fi

# --- 6. Install ml4w-dotfiles-installer fork ---
info "Installing ml4w-dotfiles-installer from $INSTALLER_REPO"
mkdir -p "$(dirname "$INSTALLER_DIR")"
if [ -d "$INSTALLER_DIR/.git" ]; then
    git -C "$INSTALLER_DIR" pull --ff-only
else
    git clone --depth=1 "$INSTALLER_REPO" "$INSTALLER_DIR"
fi
make -C "$INSTALLER_DIR" install

if [ "$INSTALLER_ONLY" = true ]; then
    info "Installer staged. Re-run without --installer-only to apply the profile."
    exit 0
fi

# --- 7. Run installer against the Debian profile ---
if ! command -v ml4w-dotfiles-installer >/dev/null 2>&1; then
    if [ -x "$HOME/.local/bin/ml4w-dotfiles-installer" ]; then
        export PATH="$HOME/.local/bin:$PATH"
    else
        die "ml4w-dotfiles-installer not on PATH after install. Add ~/.local/bin to PATH."
    fi
fi

info "Running installer against $PROFILE"
ml4w-dotfiles-installer --install "$PROFILE"
