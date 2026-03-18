#!/usr/bin/env bash

echo ":: Running Migration script..."

# Move nvim folder to .config
NVIM_DIR="$HOME/.config/nvim"
if [ -L $NVIM_DIR ]; then
    current_link_target=$(realpath -m "$NVIM_DIR")
    if [[ "$current_link_target" == *".mydotfiles"* ]]; then
        rm $NVIM_DIR
        echo "Symlink $NVIM_DIR removed"
        if [ -d $current_link_target ]; then
            cp -rf $current_link_target ~/.config
            if [ -d $NVIM_DIR ]; then
                rm -rf $current_link_target
            fi
            echo "$current_link_target moved to ~./config"
        fi
    fi
fi

# Remove legacy ML4W Apps
FLATPAK_ID="com.ml4w.welcome"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi
FLATPAK_ID="com.ml4w.settings"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi
FLATPAK_ID="com.ml4w.sidebar"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi