# ------------------------------------------------------
# Disable display manager
# ------------------------------------------------------
disman=0
if [ -f /etc/systemd/system/display-manager.service ]; then
echo -e "${GREEN}"
cat <<"EOF"
 ___                            _              _   
|_ _|_ __ ___  _ __   ___  _ __| |_ __ _ _ __ | |_ 
 | || '_ ` _ \| '_ \ / _ \| '__| __/ _` | '_ \| __|
 | || | | | | | |_) | (_) | |  | || (_| | | | | |_ 
|___|_| |_| |_| .__/ \___/|_|   \__\__,_|_| |_|\__|
              |_|                                  

EOF
echo -e "${NONE}"
    echo "An active display manager has been dedected."
    echo ""
    if [ $profile == "Hyprland" ]; then
        echo "IMPORTANT: Starting Hyprland from tty (terminal) with command Hyprland is recommended."
        echo "Login with display managers could fail and could have negative side effects on some devices."
    fi
    if [ $profile == "Qtile" ]; then
        echo "PLEASE NOTE: Qtile works with Display Managers."
        echo "But if you want to use the tty based (terminal) login instead, you can disable the display manager now."
    fi
    if [ $profile == "All" ]; then
        echo "IMPORTANT: Starting Hyprland from tty (terminal) with command Hyprland is recommended."
        echo "Login with display managers could fail and could have negative side effects on some devices."
        echo "PLEASE NOTE: Qtile works with Display Managers."
        echo "But if you want to use the tty based (terminal) login instead, you can disable the display manager now."
    fi
    echo ""
    while true; do
        read -p "Do you want to deactive the current display manager (Yy/Nn): " yn
        case $yn in
            [Yy]* )
                if [ -f /etc/systemd/system/display-manager.service ]; then
                    sudo rm /etc/systemd/system/display-manager.service
                    echo "Current display manager removed."
                fi
                disman=1
            break;;
            [Nn]* ) 
                echo "Disable display manager skipped."
                echo "You can run ~/dotfiles/hypr/script/disablewm.sh at a later point of time if needed."
            break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo ""
else
    disman=1
fi
