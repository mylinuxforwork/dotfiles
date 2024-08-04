#!/bin/bash
generated_versions="$HOME/.config/ml4w/cache/wallpaper-generated"
rm $generated_versions/*
echo ":: Wallpaper cache cleared"
notify-send "Wallpaper cache cleared"