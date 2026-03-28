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

# openSuse: Set wallpaper engine to hyprpaper
if command -v zypper &> /dev/null; then 
    if [ -d $HOME/.mydotfiles/com.ml4w.dotfiles ]; then
        WAYPAPER_CONFIG="$HOME/.mydotfiles/com.ml4w.dotfiles/.config/waypaper/config.ini"
        sed -i 's/awww/hyprpaper/g' "$WAYPAPER_CONFIG"
        echo ":: Successfully switched from awww to hyprpaper."
    if [ -d $HOME/.mydotfiles/com.ml4w.dotfiles.stable ]; then
        WAYPAPER_CONFIG="$HOME/.mydotfiles/com.ml4w.dotfiles.stable/.config/waypaper/config.ini"
        sed -i 's/awww/hyprpaper/g' "$WAYPAPER_CONFIG"
        echo ":: Successfully switched from awww to hyprpaper."
    fi 
fi

# Fedora: Set wallpaper engine to awww
if command -v dnf &> /dev/null; then 
    if [ -d $HOME/.mydotfiles/com.ml4w.dotfiles ]; then
        WAYPAPER_CONFIG="$HOME/.mydotfiles/com.ml4w.dotfiles/.config/waypaper/config.ini"
        sed -i 's/swww/awww/g' "$WAYPAPER_CONFIG"
        echo ":: Successfully switched from swww to awww."
    if [ -d $HOME/.mydotfiles/com.ml4w.dotfiles.stable ]; then
        WAYPAPER_CONFIG="$HOME/.mydotfiles/com.ml4w.dotfiles.stable/.config/waypaper/config.ini"
        sed -i 's/swww/awww/g' "$WAYPAPER_CONFIG"
        echo ":: Successfully switched from swww to awww."
    fi 
fi

# Arch: Set wallpaper engine to awww
if command -v pacman &> /dev/null; then 
    if [ -d $HOME/.mydotfiles/com.ml4w.dotfiles ]; then
        WAYPAPER_CONFIG="$HOME/.mydotfiles/com.ml4w.dotfiles/.config/waypaper/config.ini"
        sed -i 's/swww/awww/g' "$WAYPAPER_CONFIG"
        echo ":: Successfully switched from swww to awww."
    fi
    if [ -d $HOME/.mydotfiles/com.ml4w.dotfiles.stable ]; then
        WAYPAPER_CONFIG="$HOME/.mydotfiles/com.ml4w.dotfiles.stable/.config/waypaper/config.ini"
        sed -i 's/swww/awww/g' "$WAYPAPER_CONFIG"
        echo ":: Successfully switched from swww to awww."
    fi 
fi