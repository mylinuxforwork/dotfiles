# ------------------------------------------------------
# Restore ML4W Hyprland Settings app
# ------------------------------------------------------

echo -e "${GREEN}"
figlet -f smslant "Settings"
echo -e "${NONE}"


if [ "$restored" == "1" ]; then
    if [ -f ~/.config/ml4w/settings/settings.json ] ;then
        # python restore.py
        python $install_directory/dotfiles/restore.py
        rm ~/.config/ml4w/settings/settings.json
        echo ":: Legacy settings.json removed"
    fi
fi

echo ":: Starting restore settings"

# Replace waybar_timeformat and waybar_dateformat
if [ -f ~/.config/ml4w/settings/waybar_timeformat.sh ] ;then
    replace_time=$(cat ~/.config/ml4w/settings/waybar_timeformat.sh)
    replace_date=$(cat ~/.config/ml4w/settings/waybar_dateformat.sh)
    search_str="\"format\""
    replace_str="\ \ \ \ \"format\": \"{:$replace_time $replace_date}\","
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "clock" "$HOME/.config/waybar/modules.json"
    echo ":: waybar_timeformat restored"
fi

# Replace waybar_custom_timedateformat
if [ -f ~/.config/ml4w/settings/waybar_custom_timedateformat.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_custom_timedateformat.sh)
    if [ ! -z "$replace_value" ] ;then
        search_str="\"format\""
        replace_str="\ \ \ \ \"format\": \"{:$replace_value}\","
        _replaceLineInFileCheckpoint "$search_str" "$replace_str" "clock" "$HOME/.config/waybar/modules.json"
        echo ":: waybar_custom_timedateformat restored"
    fi
fi

# Replace dunst_position
if [ -f ~/.config/ml4w/settings/dunst_position.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/dunst_position.sh)
    search_str="origin"
    replace_str="\ \ \ \ origin = $replace_value"
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "global" "$HOME/.config/dunst/dunstrc"
    echo ":: dunst_position restored"
fi

# Replace waybar_workspaces
if [ -f ~/.config/ml4w/settings/waybar_workspaces.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_workspaces.sh)
    search_str="\"*\""
    replace_str="\ \ \ \ \ \ \"*\": $replace_value"
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "persistent-workspaces" "$HOME/.config/waybar/modules.json"
    echo ":: waybar_workspaces restored"
fi

# Replace waybar_taskbar
if [ -f ~/.config/ml4w/settings/waybar_taskbar.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_taskbar.sh)
    search_str="taskbar"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"wlr\/taskbar\","
    else
        replace_str="\/\/\"wlr\/taskbar\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-bottom/config"
    echo ":: waybar_taskbar restored"
fi

# Replace waybar_network
if [ -f ~/.config/ml4w/settings/waybar_network.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_network.sh)
    search_str="network"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"network\","
    else
        replace_str="\/\/\"network\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-minimal/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/starter/config"
    echo ":: waybar_network restored"
fi

# Replace waybar_backlight
if [ -f ~/.config/ml4w/settings/waybar_backlight.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_backlight.sh)
    search_str="backlight"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"backlight\","
    else
        replace_str="\/\/\"backlight\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-minimal/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/starter/config"
    echo ":: waybar_backlight restored"
fi

# Replace waybar_chatgpt
if [ -f ~/.config/ml4w/settings/waybar_chatgpt.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_chatgpt.sh)
    search_str="chatgpt"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\ \ \ \ \ \ \"custom\/chatgpt\","
    else
        replace_str="\ \ \ \ \ \ \/\/\"custom\/chatgpt\","
    fi
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "links" "$HOME/.config/waybar/modules.json"
    echo ":: waybar_chatgpt restored"
fi

# Replace waybar_systray
if [ -f ~/.config/ml4w/settings/waybar_systray.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_systray.sh)
    search_str="tray"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"tray\","
    else
        replace_str="\/\/\"tray\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-minimal/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/starter/config"
    echo ":: waybar_systray restored"
fi

# Replace waybar_screenlock
if [ -f ~/.config/ml4w/settings/waybar_screenlock.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_screenlock.sh)
    search_str="hypridle"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\ \ \ \ \ \ \"custom\/hypridle\","
    else
        replace_str="\ \ \ \ \ \ \/\/\"custom\/hypridle\","
    fi
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "group\/tools" "$HOME/.config/waybar/modules.json"
    echo ":: waybar_screenlock restored"
fi

# Replace waybar_window
if [ -f ~/.config/ml4w/settings/waybar_window.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_window.sh)
    search_str="window"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"hyprland\/window\","
    else
        replace_str="\/\/\"hyprland\/window\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-minimal/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/starter/config"
    echo ":: waybar_window restored"
fi

# Replace waybar_settings
if [ -f ~/.config/ml4w/settings/waybar_settings.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_settings.sh)
    search_str="settings"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"group\/settings\","
    else
        replace_str="\/\/\"group\/settings\","
    fi
    _replaceLineInFileCheckpoint $search_str $replace_str "modules-left" "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFileCheckpoint $search_str $replace_str "modules-left" "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFileCheckpoint $search_str $replace_str "modules-left" "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFileCheckpoint $search_str $replace_str "modules-left" "$HOME/.config/waybar/themes/ml4w-bottom/config"
    _replaceLineInFileCheckpoint $search_str $replace_str "modules-left" "$HOME/.config/waybar/themes/ml4w-minimal/config"
    echo ":: waybar_settings restored"
fi

# Replace waybar_appmenu
if [ -f ~/.config/ml4w/settings/waybar_appmenu.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_appmenu.sh)
    search_str="appmenu"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"custom\/appmenu\","
    else
        replace_str="\/\/\"custom\/appmenu\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-blur-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-bottom/config"
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/starter/config"
    echo ":: waybar_appmenu restored"
fi

# Replace waybar_appmenuicon
if [ -f ~/.config/ml4w/settings/waybar_appmenu.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/waybar_appmenu.sh)
    search_str="appmenuicon"
    if [[ $replace_value == "True" ]] ;then
        replace_str="\"custom\/appmenuicon\","
    else
        replace_str="\/\/\"custom\/appmenuicon\","
    fi
    _replaceLineInFile $search_str $replace_str "$HOME/.config/waybar/themes/ml4w-minimal/config"
    echo ":: waybar_appmenuicon restored"
fi

# Replace hypridle_hyprlock_timeout
if [ -f ~/.config/ml4w/settings/hypridle_hyprlock_timeout.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/hypridle_hyprlock_timeout.sh)
    search_str="timeout"
    replace_str="\ \ \ \ timeout = $replace_value"
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "HYPRLOCK TIMEOUT" "$HOME/.config/hypr/hypridle.conf"
    echo ":: hypridle_hyprlock_timeout restored"
fi

# Replace hypridle_dpms_timeout
if [ -f ~/.config/ml4w/settings/hypridle_dpms_timeout.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/hypridle_dpms_timeout.sh)
    search_str="timeout"
    replace_str="\ \ \ \ timeout = $replace_value"
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "DPMS TIMEOUT" "$HOME/.config/hypr/hypridle.conf"
    echo ":: hypridle_dpms_timeout restored"
fi

# Replace hypridle_suspend_timeout
if [ -f ~/.config/ml4w/settings/hypridle_suspend_timeout.sh ] ;then
    replace_value=$(cat ~/.config/ml4w/settings/hypridle_suspend_timeout.sh)
    search_str="timeout"
    replace_str="\ \ \ \ timeout = $replace_value"
    _replaceLineInFileCheckpoint "$search_str" "$replace_str" "SUSPEND TIMEOUT" "$HOME/.config/hypr/hypridle.conf"
    echo ":: hypridle_suspend_timeout restored"
fi
echo
