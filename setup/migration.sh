#!/usr/bin/env bash

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
FLATPAK_ID="com.ml4w.dotfilesinstaller"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi

# Update Wallpaper Engine in waypaper
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
if [ -f $WAYPAPER_CONFIG ]; then
    if command -v zypper &> /dev/null; then 
        sed -i 's/awww/hyprpaper/g' "$WAYPAPER_CONFIG"
        info "Successfully switched from awww to hyprpaper."
    else
        sed -i 's/swww/awww/g' "$WAYPAPER_CONFIG"
        info "Successfully switched from swww to awww."    
    fi
fi

# Remove matugen from .local/bin
if [ -f $HOME/.local/bin/matugen ]; then
    rm "$HOME/.local/bin/matugen"
    info "matugen removed from ~/.local/bin"
fi

# Remove default52.conf windowrule
if [ -f $HOME/.config/hypr/conf/windowrules/default52.conf ]; then
    rm "$HOME/.config/hypr/conf/windowrules/default52.conf"
    info "default52.conf windowrule removed."
fi