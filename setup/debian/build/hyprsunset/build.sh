#!/usr/bin/env bash
# hyprsunset: CMake/C++. Runtime depends on libhyprutils + libhyprlang
# (both in Debian forky). Build deps come from build/Containerfile.

set -euo pipefail

export PKG_NAME=hyprsunset
export PKG_VERSION="${HYPRSUNSET_VERSION:?versions.env not sourced}"
export PKG_REPO="${HYPRSUNSET_REPO:?versions.env not sourced}"

source "${ML4W_DEBIAN_ROOT}/build/common.sh"

clone_src

cmake -S "$SRC_DIR" -B "$SRC_DIR/build" \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr
cmake --build "$SRC_DIR/build" --parallel

DESTDIR="$DESTDIR" cmake --install "$SRC_DIR/build"

fpm_pack "$DESTDIR" \
    -d "libhyprutils11" \
    -d "libhyprlang2" \
    -d "libc6"
