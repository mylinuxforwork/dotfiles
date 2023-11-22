# ------------------------------------------------------
# Disable display manager
# ------------------------------------------------------
disman=0
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
    echo "An active display manager has been dedected."
    echo ""
    if [[ $profile == *"Hyprland"* ]]; then
        echo "IMPORTANT: Starting Hyprland from tty (terminal) with command Hyprland is recommended."
        echo "Login with display managers could fail and could have negative side effects on some devices."
    fi
    if [[ $profile == *"Qtile"* ]]; then
        echo "PLEASE NOTE: Qtile works with Display Managers."
        echo "But if you want to use the tty based (terminal) login instead, you can disable the display manager now."
    fi
    echo ""

    if gum confirm "Do you want to deactive the current display manager?" ;then
        if [ -f /etc/systemd/system/display-manager.service ]; then
            sudo rm /etc/systemd/system/display-manager.service
            echo "Current display manager removed."
        fi
        disman=1
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo "Disable display manager skipped."
        echo "You can run ~/dotfiles/hypr/script/disablewm.sh at a later point of time if needed."
    fi
    echo ""
else
    disman=1
fi
