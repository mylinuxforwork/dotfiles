#!/usr/bin/env bash
#                    __
#  _    _____ ___ __/ /  ___ _____
# | |/|/ / _ `/ // / _ \/ _ `/ __/
# |__,__/\_,_/\_, /_.__/\_,_/_/
#            /___/
#

# -----------------------------------------------------
# Prevent duplicate launches: only the first parallel
# invocation proceeds; all others exit immediately.
# -----------------------------------------------------

exec 200>/tmp/waybar-launch.lock
flock -n 200 || exit 0

# -----------------------------------------------------
# Quit all running waybar instances
# -----------------------------------------------------

killall waybar || true
pkill waybar || true
sleep 0.5

# -----------------------------------------------------
# Default theme: /THEMEFOLDER;/VARIATION
# -----------------------------------------------------

default_theme="/ml4w-modern;/ml4w-modern/default"

# -----------------------------------------------------
# Remove incompatible themes
# -----------------------------------------------------

if [ -f ~/.config/ml4w/settings/waybar-theme.sh ]; then
    themestyle=$(cat ~/.config/ml4w/settings/waybar-theme.sh)
    case "$themestyle" in
    "/ml4w-modern;/ml4w-modern/light")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    "/ml4w-modern;/ml4w-modern/dark")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    "/ml4w;/ml4w/light")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    "/ml4w;/ml4w/dark")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    *)
        echo
        ;;
    esac
    if [ -d $HOME/.config/waybar/themes/ml4w-modern/light ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w-modern/light
    fi
    if [ -d $HOME/.config/waybar/themes/ml4w-modern/dark ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w-modern/dark
    fi
    if [ -d $HOME/.config/waybar/themes/ml4w/light ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w/light
    fi
    if [ -d $HOME/.config/waybar/themes/ml4w/dark ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w/dark
    fi
fi

# -----------------------------------------------------
# Get current theme information from ~/.config/ml4w/settings/waybar-theme.sh
# -----------------------------------------------------

if [ -f ~/.config/ml4w/settings/waybar-theme.sh ]; then
    themestyle=$(cat ~/.config/ml4w/settings/waybar-theme.sh)
else
    touch ~/.config/ml4w/settings/waybar-theme.sh
    echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
    themestyle=$default_theme
fi

IFS=';' read -ra arrThemes <<<"$themestyle"
echo ":: Theme: ${arrThemes[0]}"

if [ ! -f ~/.config/waybar/themes${arrThemes[1]}/style.css ]; then
    themestyle=$default_theme
fi

# -----------------------------------------------------
# Loading the configuration
# -----------------------------------------------------

config_file="config"
style_file="style.css"

# Standard files can be overwritten with an existing config-custom or style-custom.css
if [ -f ~/.config/waybar/themes${arrThemes[0]}/config-custom ]; then
    config_file="config-custom"
fi
if [ -f ~/.config/waybar/themes${arrThemes[1]}/style-custom.css ]; then
    style_file="style-custom.css"
fi

# Check if waybar-disabled file exists
if [ ! -f $HOME/.config/ml4w/settings/waybar-disabled ]; then
    HYPRLAND_SIGNATURE=$(hyprctl instances -j | jq -r '.[0].instance')
    HYPRLAND_INSTANCE_SIGNATURE="$HYPRLAND_SIGNATURE" waybar -c ~/.config/waybar/themes${arrThemes[0]}/$config_file -s ~/.config/waybar/themes${arrThemes[1]}/$style_file &
    # env GTK_DEBUG=interactive waybar -c ~/.config/waybar/themes${arrThemes[0]}/$config_file -s ~/.config/waybar/themes${arrThemes[1]}/$style_file &
else
    echo ":: Waybar disabled"
fi

# Explicitly release the lock (optional) -> flock releases on exit
flock -u 200
exec 200>&-