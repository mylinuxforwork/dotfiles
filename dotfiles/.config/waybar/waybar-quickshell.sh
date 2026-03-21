#!/usr/bin/env bash

theme_file="$HOME/.config/ml4w/settings/waybar-theme.sh"
default_theme="ml4w-glass-center"

if [ -f "$theme_file" ]; then
    themestyle=$(cat "$theme_file")
    [[ -z "$themestyle" ]] && themestyle="$default_theme"
else
    themestyle="$default_theme"
    echo "$themestyle" > "$theme_file"
fi

# Normalize to full FOLDER;VARIATION
if [[ "$themestyle" != *";"* ]]; then
    folder="$themestyle"
    base="$HOME/.config/waybar/themes/$folder"

    if [ -d "$base/default" ]; then
        themestyle="/$folder;/$folder/default"
    elif [ -d "$base/dark" ]; then
        themestyle="/$folder;/$folder/dark"
    elif [ -d "$base/light" ]; then
        themestyle="/$folder;/$folder/light"
    elif [ -f "$base/style.css" ]; then
        # direct style.css in folder
        themestyle="/$folder;/$folder"
    else
        # fallback to default_theme
        themestyle="/$default_theme;/$default_theme/default"
    fi

    echo "$themestyle" > "$theme_file"
fi

IFS=';' read -ra arrThemes <<<"$themestyle"
echo ":: Theme: ${arrThemes[0]}"

$HOME/.config/waybar/launch.sh

