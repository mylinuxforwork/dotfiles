# ------------------------------------------------------
# Restore
# ------------------------------------------------------

if [ -d ~/dotfiles ]; then
echo -e "${GREEN}"
cat <<"EOF"
 ____           _                 
|  _ \ ___  ___| |_ ___  _ __ ___ 
| |_) / _ \/ __| __/ _ \| '__/ _ \
|  _ <  __/\__ \ || (_) | | |  __/
|_| \_\___||___/\__\___/|_|  \___|
                                  
EOF
echo -e "${NONE}"
    restored=0
    echo "The script will try to restore existing configurations."
    echo "PLEASE NOTE: Restoring is not possible with version < 2.5 of the dotfiles."
    echo "In that case, please use the autamated backup or create your own backup manually."
    echo ""
    echo "The following configurations can be transferred into the new installation."
    if [ -f ~/dotfiles/.bashrc ]; then
        echo ".bashrc file: ~/dotfiles/.bashrc"
    fi
    if [ $profile == "Hyprland" ] || [ $profile == "All" ]; then
        if [ -f ~/dotfiles/hypr/conf/keyboard.conf ]; then
            echo "Hyprland keyboard layout: ~/dotfiles/hypr/conf/keyboard.conf"
        fi
        if [ -f ~/dotfiles/hypr/conf/monitor.conf ]; then
            echo "Hyprland monitor setup: ~/dotfiles/hypr/conf/monitor.conf"
        fi
        if [ -f ~/dotfiles/hypr/conf/keybindings.conf ]; then
            echo "Hyprland keybindings: ~/dotfiles/hypr/conf/keybindings.conf"
        fi
    fi
    if [ $profile == "Qtile" ] || [ $profile == "All" ]; then
        if [ -f ~/dotfiles/qtile/conf/keyboard.py ]; then
            echo "Qtile keyboard layout: ~/dotfiles/qtile/conf/keyboard.py"
        fi
    fi
    echo ""

    while true; do
        read -p "Do you want to restore the files now and use it on your new installation (Yy/Nn): " yn
        case $yn in
            [Yy]* )
                if [ -f ~/dotfiles/.bashrc ]; then
                    cp ~/dotfiles/.bashrc ~/dotfiles-versions/$version/
                    echo ".bashrc restored!"
                fi
                if [ $profile == "Hyprland" ] || [ $profile == "All" ]; then                
                    if [ -f ~/dotfiles/hypr/conf/keyboard.conf ]; then
                        cp ~/dotfiles/hypr/conf/keyboard.conf ~/dotfiles-versions/$version/hypr/conf/
                        echo "Hyprland keyboard.conf restored!"
                    fi
                    if [ -f ~/dotfiles/hypr/conf/monitor.conf ]; then
                        cp ~/dotfiles/hypr/conf/monitor.conf ~/dotfiles-versions/$version/hypr/conf/
                        echo "Hyprland monitor.conf restored!"                
                    fi
                    if [ -f ~/dotfiles/hypr/conf/keybindings.conf ]; then
                        cp ~/dotfiles/hypr/conf/keybindings.conf ~/dotfiles-versions/$version/hypr/conf/
                        echo "Hyprland keybindings.conf restored!"
                    fi
                fi
                if [ $profile == "Qtile" ] || [ $profile == "All" ]; then
                    if [ -f ~/dotfiles/qtile/conf/keyboard.py ]; then
                        cp ~/dotfiles/qtile/conf/keyboard.py ~/dotfiles-versions/$version/qtile/conf/
                        echo "Qtile keyboard.py restored!"
                    fi
                fi
                restored=1
            break;;
            [Nn]* ) 
            break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo ""
fi