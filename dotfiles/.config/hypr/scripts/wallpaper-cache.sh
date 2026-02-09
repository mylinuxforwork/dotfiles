#!/usr/bin/env bash

# Notifications
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"

ml4w_cache_folder="$HOME/.cache/ml4w/hyprland-dotfiles"
generated_versions="$ml4w_cache_folder/wallpaper-generated"
rm $generated_versions/*
echo ":: Wallpaper cache cleared"
notify_user \
        --a "System" \
        --m "Wallpaper cache cleared"
