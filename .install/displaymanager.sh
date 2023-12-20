# ------------------------------------------------------
# Disable display manager
# ------------------------------------------------------
disman=0
profile="Hyprland"
if [ -f /etc/systemd/system/display-manager.service ]; then
echo -e "${GREEN}"
cat <<"EOF"
 ____  _           _               __  __                                   
|  _ \(_)___ _ __ | | __ _ _   _  |  \/  | __ _ _ __   __ _  __ _  ___ _ __ 
| | | | / __| '_ \| |/ _` | | | | | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|
| |_| | \__ \ |_) | | (_| | |_| | | |  | | (_| | | | | (_| | (_| |  __/ |   
|____/|_|___/ .__/|_|\__,_|\__, | |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|   
            |_|            |___/                            |___/           

EOF
echo -e "${NONE}"
    echo "An active display manager has been detected."
    echo ""
    if [[ $profile == *"Hyprland"* ]]; then
        echo "IMPORTANT: Starting Hyprland works from tty (terminal) with command Hyprland or with the display manager SDDM (> 0.20.0 already installed or the latest git version (yay -S sddm-git)."
        echo "Please check: https://wiki.hyprland.org/hyprland-wiki/pages/Getting-Started/Master-Tutorial/#launching-hyprland"
        echo "Login with other display managers could fail and could have negative side effects on some devices."
        echo ""
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [ -f /usr/share/wayland-sessions/qtile-wayland.desktop ]; then
            sudo mv /usr/share/wayland-sessions/qtile-wayland.desktop /usr/share/wayland-sessions/qtile-wayland.bak
        fi
        echo "PLEASE NOTE: Qtile works with Display Managers."
        echo "But if you want to use the tty based (terminal) login instead, you can disable the display manager now."
        echo "If you install the aliases with the included .bashrc, you can start Qtile with the command Qtile."
        echo ""
    fi

    if gum confirm "Do you want to enable/update to sddm or disable the display manager?" --affirmative "Enable" --negative "Disable" ;then
        if [ -f /etc/systemd/system/display-manager.service ]; then
            sudo rm /etc/systemd/system/display-manager.service
        fi
        sudo systemctl enable sddm.service

        if [ ! -d /etc/sddm.conf.d/ ]; then
            sudo mkdir /etc/sddm.conf.d
            echo "Folder /etc/sddm.conf.d created."
        fi

        sudo cp sddm/sddm.conf /etc/sddm.conf.d/
        echo "File /etc/sddm.conf.d/sddm.conf updated."

        if [ -f /usr/share/sddm/themes/sugar-candy/theme.conf ]; then
            if [ -f ~/.cache/current_wallpaper.jpg ]; then
                sudo cp ~/.cache/current_wallpaper.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/current_wallpaper.jpg
                echo "Current wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"
            else
                sudo cp wallpapers/default.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/current_wallpaper.jpg
                echo "Default wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"
            fi

            sudo cp sddm/theme.conf /usr/share/sddm/themes/sugar-candy/
            echo "File theme.conf updated in /usr/share/sddm/themes/sugar-candy/"
        fi
    elif [ $? -eq 130 ]; then
        exit 130
    else
        if [ -f /etc/systemd/system/display-manager.service ]; then
            sudo rm /etc/systemd/system/display-manager.service
            echo "Current display manager removed."
        fi
        disman=1
    fi
    echo ""
else
    disman=1
fi
