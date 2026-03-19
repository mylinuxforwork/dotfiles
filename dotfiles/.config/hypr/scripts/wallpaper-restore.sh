#!/usr/bin/env bash
#                _ _
# __      ____ _| | |_ __   __ _ _ __   ___ _ __
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                   |_|         |_|
#
# -----------------------------------------------------
# Restore last wallpaper
# -----------------------------------------------------

# -----------------------------------------------------
# Set defaults
# -----------------------------------------------------

ml4w_cache_folder="$HOME/.cache/ml4w/hyprland-dotfiles"
defaultwallpaper="$HOME/.config/ml4w/wallpapers/default.jpg"
cachefile="$ml4w_cache_folder/current_wallpaper"

# -----------------------------------------------------
# Get current wallpaper
# -----------------------------------------------------

if [ -f "$cachefile" ]; then
    wallpaper=$(cat "$cachefile")

    # Guard against empty cache
    if [ -z "$wallpaper" ]; then
        echo ":: Cache file empty. Using default."
        wallpaper="$defaultwallpaper"
    else
        # Expand leading ~ only if present
        if [[ $wallpaper == ~* ]]; then
            wallpaper="${wallpaper/#\~/$HOME}"
        fi

        # Normalize path (handles spaces safely)
        wallpaper=$(realpath -m "$wallpaper")

        # Ensure path is absolute
        if [[ "$wallpaper" != /* ]]; then
            echo ":: Path is not absolute. Using default."
            wallpaper="$defaultwallpaper"
        fi

        # Handle broken symlinks
        if [ -L "$wallpaper" ] && [ ! -e "$wallpaper" ]; then
            echo ":: Wallpaper symlink is broken. Using default."
            wallpaper="$defaultwallpaper"
        fi

        # Validate file existence
        if [ -f "$wallpaper" ]; then
            # Validate file type (basic extension check)
            case "$wallpaper" in
                *.jpg|*.jpeg|*.png|*.bmp|*.gif)
                    echo ":: Wallpaper $wallpaper exists"
                    ;;
                *)
                    echo ":: Not a valid image file. Using default."
                    wallpaper="$defaultwallpaper"
                    ;;
            esac
        else
            echo ":: Wallpaper $wallpaper does not exist. Using default."
            wallpaper="$defaultwallpaper"
        fi
    fi
else
    echo ":: $cachefile does not exist. Using default wallpaper."
    wallpaper="$defaultwallpaper"
fi

# -----------------------------------------------------
# Set wallpaper
# -----------------------------------------------------

echo ":: Setting wallpaper with source image $wallpaper"
if [ -f "$HOME/.local/bin/waypaper" ]; then
    export PATH="$PATH:$HOME/.local/bin/"
fi
waypaper --wallpaper "$wallpaper"
