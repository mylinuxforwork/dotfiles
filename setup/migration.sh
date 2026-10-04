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

if [ -f $HOME/.config/ml4w/settings/wallpaper-effect.sh ]; then
    mv $HOME/.config/ml4w/settings/wallpaper-effect.sh $HOME/.config/ml4w/settings/wallpaper-effect
fi

if [ -f $HOME/.config/ml4w/settings/wallpaper-automation.sh ]; then
    mv $HOME/.config/ml4w/settings/wallpaper-automation.sh $HOME/.config/ml4w/settings/wallpaper-automation
fi

# Update an old default editor.sh that the user did not change. Old
# releases shipped only the line "gnome-text-editor" (or "mousepad"). That
# line drops the file names that callers such as "ml4w-dock edit" give.
# The update restores the old settings folder, so the new default editor.sh
# does not replace it.
ml4w_migrate_editor() {
    local editor_file="$HOME/.config/ml4w/settings/editor.sh"
    [ -f "$editor_file" ] || return 0
    local editor_cmd
    editor_cmd="$(< "$editor_file")"
    case "$editor_cmd" in
        gnome-text-editor | mousepad)
            # shellcheck disable=SC2016 # "$@" must stay literal in the new file
            printf '#!/bin/bash\n%s "$@"\n' "$editor_cmd" > "$editor_file"
            info "editor.sh updated: $editor_cmd now opens the given files"
            ;;
    esac
}
ml4w_migrate_editor
unset -f ml4w_migrate_editor
