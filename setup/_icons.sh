#!/usr/bin/env bash
# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

if [ -d ~/.local/share/icons/Colloid ]; then
    rm -rf ~/.local/share/icons/Colloid
fi

if [ -d ~/.local/share/icons/Colloid-Dark ]; then
    rm -rf ~/.local/share/icons/Colloid-Dark
fi

if [ -d ~/.local/share/icons/Colloid-Light ]; then
    rm -rf ~/.local/share/icons/Colloid-Light
fi

tar -xf $SCRIPT_DIR/icons/01-Colloid.tar.xz -C ~/.local/share/icons/

if [ -d ~/.local/share/icons/Colloid/actions ]; then
    rm -rf ~/.local/share/icons/Colloid/actions
fi

if [ -f ~/.local/share/icons/Colloid/actions@2x ]; then
    rm ~/.local/share/icons/Colloid/actions@2x
fi

