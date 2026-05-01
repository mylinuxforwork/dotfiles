#!/usr/bin/env bash
# SwayNotificationCenter (swaync): Meson/Vala. Build deps in
# build/Containerfile (valac, meson, libgtk-layer-shell-dev,
# libgtk4-layer-shell-dev, scdoc, libgudev-1.0-dev, libpulse-dev,
# libnotify-dev).

set -euo pipefail

export PKG_NAME=swaync
export PKG_VERSION="${SWAYNC_VERSION:?versions.env not sourced}"
export PKG_REPO="${SWAYNC_REPO:?versions.env not sourced}"

source "${MYML4W_ROOT}/build/common.sh"

clone_src

meson setup "$SRC_DIR/build" "$SRC_DIR" \
    --prefix=/usr \
    --buildtype=release \
    --wrap-mode=nodownload

ninja -C "$SRC_DIR/build"

DESTDIR="$DESTDIR" ninja -C "$SRC_DIR/build" install

fpm_pack "$DESTDIR" \
    -d "libgtk-3-0t64 | libgtk-3-0" \
    -d "libgtk-layer-shell0" \
    -d "libgudev-1.0-0" \
    -d "libnotify4" \
    -d "libpulse0" \
    -d "libgee-0.8-2" \
    -d "libjson-glib-1.0-0" \
    -d "libhandy-1-0"
