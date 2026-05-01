#!/usr/bin/env bash
# Shared helpers sourced by every build/<pkg>/build.sh.
# Runs natively on a Debian forky host (default) or inside the podman
# test container (opt-in). Build deps come from build/build-deps.txt
# plus `gem install fpm`.

set -euo pipefail

: "${MYML4W_ROOT:?must be set by caller}"
: "${PKG_NAME:?must be set by caller}"
: "${PKG_VERSION:?must be set by caller}"
: "${PKG_REPO:?must be set by caller}"

WORK_DIR="${WORK_DIR:-${MYML4W_ROOT}/build/work/${PKG_NAME}}"
SRC_DIR="${WORK_DIR}/src"
DESTDIR="${WORK_DIR}/install"
DIST_DIR="${MYML4W_ROOT}/dist"

mkdir -p "$WORK_DIR" "$DIST_DIR"
rm -rf "$SRC_DIR" "$DESTDIR"

clone_src() {
    local tag="$PKG_VERSION"
    echo ":: cloning $PKG_REPO @ $tag"
    git clone --depth=1 --branch "$tag" "$PKG_REPO" "$SRC_DIR"
}

# strip leading 'v' from version tag for .deb versioning
deb_version() {
    echo "${PKG_VERSION#v}"
}

# Wrap fpm with the conventions we use across all built packages.
# Args: dest_destdir [extra fpm args...]
fpm_pack() {
    local dest=$1; shift
    local ver
    ver=$(deb_version)
    cd "$dest"
    fpm -s dir -t deb \
        -n "$PKG_NAME" \
        -v "$ver" \
        --license "see upstream" \
        --maintainer "thywyn <thywyn@hotmail.com>" \
        --vendor "myml4w" \
        --description "$PKG_NAME built from $PKG_REPO @ $PKG_VERSION" \
        --url "$PKG_REPO" \
        --deb-no-default-config-files \
        -p "${DIST_DIR}/${PKG_NAME}_${ver}_$(dpkg --print-architecture).deb" \
        --force \
        "$@" \
        .
}
