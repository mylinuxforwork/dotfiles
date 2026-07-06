#!/usr/bin/env bash

# Assume grimblast was installed manually, and uninstall instances
while [ -n "$(which grimblast 2>/dev/null)" ]; do
    sudo rm -v "$(which grimblast)"
done

# Install grimblast from source
GRIMBLAST_BUILD_DIR=$(mktemp -d)
trap 'rm -fr "$GRIMBLAST_BUILD_DIR"' EXIT
git clone --depth=1 https://github.com/hyprwm/contrib.git "$GRIMBLAST_BUILD_DIR"
make -C "$GRIMBLAST_BUILD_DIR/grimblast"
sudo make -C "$GRIMBLAST_BUILD_DIR/grimblast" install
