#!/usr/bin/env bash
# nwg-dock-hyprland: Go binary + static resources. Upstream Makefile
# installs straight into / (no DESTDIR support), so we run the install
# steps manually into our staging dir.

set -euo pipefail

export PKG_NAME=nwg-dock-hyprland
export PKG_VERSION="${NWG_DOCK_HYPRLAND_VERSION:?versions.env not sourced}"
export PKG_REPO="${NWG_DOCK_HYPRLAND_REPO:?versions.env not sourced}"

source "${ML4W_DEBIAN_ROOT}/build/common.sh"

clone_src

cd "$SRC_DIR"
go build -v -trimpath -o "bin/nwg-dock-hyprland" .

mkdir -p "$DESTDIR/usr/bin" "$DESTDIR/usr/share/nwg-dock-hyprland"
install -m 755 bin/nwg-dock-hyprland "$DESTDIR/usr/bin/nwg-dock-hyprland"
cp -r images "$DESTDIR/usr/share/nwg-dock-hyprland/"
cp config/* "$DESTDIR/usr/share/nwg-dock-hyprland/"

fpm_pack "$DESTDIR" \
    -d "libgtk-layer-shell0" \
    -d "libgtk-3-0t64 | libgtk-3-0" \
    -d "libc6"
