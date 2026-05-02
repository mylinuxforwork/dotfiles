#!/usr/bin/env bash
# Debian forky preflight, run by ml4w-dotfiles-installer before
# packages-debian / post-debian.sh.
#
# Three things upstream installers don't need to do, but Debian does:
#   1. Refresh apt index.
#   2. Build .deb packages for the pieces that aren't in Debian
#      (hyprsunset, nwg-dock-hyprland) — see setup/debian/.
#   3. Install those .debs so the regular packages-debian step that
#      follows can resolve their runtime deps cleanly.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEBIAN_DIR="${SCRIPT_DIR}/debian"
DIST="${DEBIAN_DIR}/dist"

info() { printf '\033[1;32m::\033[0m %s\n' "$*"; }

info "apt update"
sudo DEBIAN_FRONTEND=noninteractive apt-get update

# Skip the build entirely if every package is already built. Lets
# repeat runs of the installer be cheap.
need_build=false
for pkg in hyprsunset nwg-dock-hyprland; do
    if ! ls "${DIST}/${pkg}_"*.deb >/dev/null 2>&1; then
        need_build=true
        break
    fi
done

if [ "$need_build" = true ]; then
    info "Installing build deps (apt + fpm)"
    make -C "$DEBIAN_DIR" build-deps
    info "Building .deb packages (this may take a while)"
    make -C "$DEBIAN_DIR" build-debs
else
    info "All .debs already present in $DIST — skipping build"
fi

info "Installing built .debs"
make -C "$DEBIAN_DIR" install-debs
