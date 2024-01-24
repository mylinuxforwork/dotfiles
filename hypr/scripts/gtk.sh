#!/bin/bash
# Source: https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland

config="$HOME/.config/gtk-3.0/settings.ini"
if [ ! -f "$config" ]; then exit 1; fi

gnome_schema="org.gnome.desktop.interface"
gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_size="$(grep 'gtk-cursor-theme-size' "$config" | sed 's/.*\s*=\s*//')"
font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"

echo $gtk_theme
echo $icon_theme
echo $cursor_theme
echo $cursor_size
echo $font_name

gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
gsettings set "$gnome_schema" icon-theme "$icon_theme"
gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
gsettings set "$gnome_schema" font-name "$font_name"
gsettings set "$gnome_schema" color-scheme "prefer-dark"

if [ -f ~/dotfiles/hypr/conf/cursor.conf ] ;then
    echo "exec-once = hyprctl setcursor $cursor_theme $cursor_size" > ~/dotfiles/hypr/conf/cursor.conf
    hyprctl setcursor $cursor_theme $cursor_size
fi