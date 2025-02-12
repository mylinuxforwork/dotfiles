#!/bin/bash
#   _____________ __
#  / ___/_  __/ //_/
# / (_ / / / / ,<   
# \___/ /_/ /_/|_|  
#                   
# Source: https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland

# Check that settings file exists
config="$HOME/.config/gtk-3.0/settings.ini"
if [ ! -f "$config" ]; then exit 1; fi

# Read settings file
gnome_schema="org.gnome.desktop.interface"
gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_size="$(grep 'gtk-cursor-theme-size' "$config" | sed 's/.*\s*=\s*//')"
font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
prefer_dark_theme="$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*\s*=\s*//')"
terminal=$(cat $HOME/.config/ml4w/settings/terminal.sh)

# Echo value for debugging
echo "GTK-Theme:" $gtk_theme
echo "Icon Theme:" $icon_theme
echo "Cursor Theme:" $cursor_theme
echo "Cursor Size:" $cursor_size
if [ $prefer_dark_theme == "0" ]; then
    prefer_dark_theme_value="prefer-light"
else
    prefer_dark_theme_value="prefer-dark"
fi
echo "Color Theme:" $prefer_dark_theme_value
echo "Font Name:" $font_name
echo "Terminal:" $terminal

# Update gsettings
gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
gsettings set "$gnome_schema" icon-theme "$icon_theme"
gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
gsettings set "$gnome_schema" font-name "$font_name"
gsettings set "$gnome_schema" color-scheme "$prefer_dark_theme_value"

# Update cursor for Hyprland
if [ -f ~/.config/hypr/conf/cursor.conf ]; then
    echo "exec-once = hyprctl setcursor $cursor_theme $cursor_size" >~/.config/hypr/conf/cursor.conf
    hyprctl setcursor $cursor_theme $cursor_size
fi

# Update gsettings for open any terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal "$terminal"
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal use-generic-terminal-name "true"
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings "<Ctrl><Alt>t"