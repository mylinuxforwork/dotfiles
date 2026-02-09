#!/bin/bash
#  _   _                      _               _
# | | | |_   _ _ __  _ __ ___| |__   __ _  __| | ___
# | |_| | | | | '_ \| '__/ __| '_ \ / _` |/ _` |/ _ \
# |  _  | |_| | |_) | |  \__ \ | | | (_| | (_| |  __/
# |_| |_|\__, | .__/|_|  |___/_| |_|\__,_|\__,_|\___|
#        |___/|_|
#

# Notifications
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"
APP_NAME="Hyprshade"
NOTIFICATION_ICON="video-display-symbolic"

# Remove legacy shaders folder
if [ -d $HOME/.config/hypr/shaders ]; then
    rm -rf $HOME/.config/hypr/shaders
fi

if [[ "$1" == "rofi" ]]; then

    # Open rofi to select the Hyprshade filter for toggle
    options="$(hyprshade ls | sed 's/^[ *]*//')\noff"

    # Open rofi
    choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/config-hyprshade.rasi -i -no-show-icons -l 4 -width 30 -p "Hyprshade")
    if [ ! -z $choice ]; then
        echo "hyprshade_filter=\"$choice\"" >~/.config/ml4w/settings/hyprshade.sh
        if [ "$choice" == "off" ]; then
            hyprshade off
            notify_user --a "${APP_NAME}" \
                --i "${NOTIFICATION_ICON}" \
                --s "Hyprshade turned off" \
                --m ""
            echo ":: hyprshade turned off"
        else
            notify_user --a "${APP_NAME}" \
                --i "${NOTIFICATION_ICON}" \
                --s "Hyprshade filter" \
                --m "Changing Hyprshade filter to \"$choice.\" \nToggle shader with SUPER+SHIFT+H"
        fi
    fi

else

    # Toggle Hyprshade based on the selected filter
    hyprshade_filter="blue-light-filter-50"

    # Check if hyprshade.sh settings file exists and load
    if [ -f ~/.config/ml4w/settings/hyprshade.sh ]; then
        source ~/.config/ml4w/settings/hyprshade.sh
    fi

    # Toggle Hyprshade
    if [ "$hyprshade_filter" != "off" ]; then
        if [ -z $(hyprshade current) ]; then
            echo ":: hyprshade is not running"
            hyprshade on $hyprshade_filter
            notify_user --a "${APP_NAME}" \
                --i "${NOTIFICATION_ICON}" \
                --s "Hyprshade activated" \
                --m "Current filter: $(hyprshade current)."
            echo ":: hyprshade started with $(hyprshade current)"
        else
            notify_user --a "${APP_NAME}" \
                --i "${NOTIFICATION_ICON}" \
                --s "Hyprshade deactivated" \
                --m ""
            echo ":: Current hyprshade $(hyprshade current)"
            echo ":: Switching hyprshade off"
            hyprshade off
        fi
    else
        hyprshade off
        echo ":: hyprshade turned off"
    fi

fi
