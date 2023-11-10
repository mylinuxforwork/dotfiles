# ------------------------------------------------------
# Restore
# ------------------------------------------------------

if [ -d ~/dotfiles ]; then
cat <<"EOF"
 ____           _                 
|  _ \ ___  ___| |_ ___  _ __ ___ 
| |_) / _ \/ __| __/ _ \| '__/ _ \
|  _ <  __/\__ \ || (_) | | |  __/
|_| \_\___||___/\__\___/|_|  \___|
                                  
EOF

    echo "The script will try to restore existing configurations."
    echo "PLEASE NOTE: Restoring is not possible with version < 2.5 of the dotfiles."
    echo "Keyboard layout can be defined manually in the next step."
    echo ""
    restored=0

    if [ -f ~/dotfiles/.bashrc ]; then
        while true; do
            read -p "Found existing ~/dotfiles/.bashrc Restore? (Yy/Nn): " yn
            case $yn in
                [Yy]* )
                    cp ~/dotfiles/.bashrc ~/dotfiles-versions/$version/
                    echo "Restored!"
                    restored=1
                break;;
                [Nn]* ) 
                break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi

    if [ $profile == "Hyprland" ] || [ $profile == "All" ]; then
        if [ -f ~/dotfiles/hypr/conf/keyboard.conf ]; then
            while true; do
                read -p "Found existing ~/dotfiles/hypr/conf/keyboard.conf Restore? (Yy/Nn): " yn
                case $yn in
                    [Yy]* )
                        cp ~/dotfiles/hypr/conf/keyboard.conf ~/dotfiles-versions/$version/hypr/conf/
                        echo "Restored!"
                        restored=1
                    break;;
                    [Nn]* ) 
                    break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        fi
    fi

    if [ $profile = "Hyprland" ] || [ $profile == "All" ]; then
        if [ -f ~/dotfiles/hypr/conf/monitor.conf ]; then
            while true; do
                read -p "Found existing ~/dotfiles/hypr/conf/monitor.conf Restore? (Yy/Nn): " yn
                case $yn in
                    [Yy]* )
                        cp ~/dotfiles/hypr/conf/monitor.conf ~/dotfiles-versions/$version/hypr/conf/
                        echo "Restored!"
                        restored=1
                    break;;
                    [Nn]* ) 
                    break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        fi
    fi

    if [ $profile == "Hyprland" ] || [ $profile == "All" ]; then
        if [ -f ~/dotfiles/hypr/conf/keybindings.conf ]; then
            while true; do
                read -p "Found existing ~/dotfiles/hypr/conf/keybindings.conf Restore? (Yy/Nn): " yn
                case $yn in
                    [Yy]* )
                        cp ~/dotfiles/hypr/conf/keybindings.conf ~/dotfiles-versions/$version/hypr/conf/
                        echo "Restored!"
                        restored=1
                    break;;
                    [Nn]* ) 
                    break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        fi
    fi

    if [ $profile == "Qtile" ] || [ $profile == "All" ]; then
        if [ -f ~/dotfiles/qtile/conf/keyboard.py ]; then
            while true; do
                read -p "Found existing ~/dotfiles/qtile/conf/keyboard.py Restore? (Yy/Nn): " yn
                case $yn in
                    [Yy]* )
                        cp ~/dotfiles/qtile/conf/keyboard.py ~/dotfiles-versions/$version/qtile/conf/
                        echo "Restored!"
                        restored=1
                    break;;
                    [Nn]* ) 
                    break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        fi
    fi    
    if [ $restored == 0 ]; then
        echo "Restore not possible."
    fi
    echo ""
fi