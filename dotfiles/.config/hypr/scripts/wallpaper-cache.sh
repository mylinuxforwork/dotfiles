#!/usr/bin/env bash
ml4w_cache_folder="$HOME/.cache/ml4w/hyprland-dotfiles"
generated_versions="$ml4w_cache_folder/wallpaper-generated"
rm $generated_versions/*
echo ":: Wallpaper cache cleared"
notify-send "Wallpaper cache cleared"
