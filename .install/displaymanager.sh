# ------------------------------------------------------
# Disable display manager
# ------------------------------------------------------
disman=0
echo -e "${GREEN}"
figlet "Display Manager"
echo -e "${NONE}"
if [[ $profile == *"Hyprland"* ]]; then
    echo "IMPORTANT: Starting Hyprland works from tty (terminal) with command Hyprland (recommended)." 
    echo "or you can try the display manager SDDM (> 0.20.0 already installed) or the latest git version (yay -S sddm)."
    echo "Please check: https://wiki.hyprland.org/hyprland-wiki/pages/Getting-Started/Master-Tutorial/#launching-hyprland"
    echo "Login with other display managers could fail and could have negative side effects on some devices."
    echo "If you have issues with SDDM or other display managers, you can deactivate the display manager"
    echo "at any time with the Hyprland settings script (Start from Waybar or with SUPER+CTRL+S)."
    echo ""
fi
if [[ $profile == *"Qtile"* ]]; then
    if [ -f /usr/share/wayland-sessions/qtile-wayland.desktop ]; then
        sudo mv /usr/share/wayland-sessions/qtile-wayland.desktop /usr/share/wayland-sessions/qtile-wayland.bak
        echo "Qtile Wayland Session removed."
    fi
    echo "PLEASE NOTE: Qtile works with Display Managers."
    echo "But if you want to use the tty based (terminal) login instead, you can disable the display manager now."
    echo "If you install the aliases with the included .bashrc, you can start Qtile with the command Qtile."
    echo ""
fi

if [ ! -d ~/dotfiles ];then
    if [ -f /etc/systemd/system/display-manager.service ]; then
        disman=0
        echo "You have already installed a display manager on your system."
        echo "How do you want to proceed?"
        dmsel=$(gum choose "Keep current setup" "Deactivate current display manager" "Install sddm")
    else
        disman=1
        echo "There is no display manager installed on your system."
        echo "After the installation/update of the dotfiles, you can start Hyprland with command Hyprland and Qtile with commmand Qtile (or startx)."
        echo "How do you want to proceed?"
        dmsel=$(gum choose "Keep current setup" "Install sddm")
    fi
else
    if [ -f /etc/systemd/system/display-manager.service ]; then
        disman=0
        echo "You have already installed a display manager. If your display manager is working fine, you can keep the current setup."
        echo "How do you want to proceed?"
        dmsel=$(gum choose "Keep current setup" "Deactivate current display manager" "Install sddm")
    else
        disman=1
        echo "There is no display manager installed on your system. You're starting Hyprland/Qtile with commands on tty."
        echo "How do you want to proceed?"
        dmsel=$(gum choose "Keep current setup" "Install sddm")
    fi
fi

if [ -z "${dmsel}" ] ;then
    echo "Installation canceled."
    exit
fi
if [ "$dmsel" == "Install sddm" ] ;then

    disman=0
    # Try to force the installation of sddm
    echo "Install sddm"
    yay -S --noconfirm sddm sddm-sugar-candy-git --ask 4

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

        # Cache file for holding the current wallpaper
        sudo cp wallpapers/default.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/current_wallpaper.jpg
        echo "Default wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"

        sudo cp sddm/theme.conf /usr/share/sddm/themes/sugar-candy/
        sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.jpg"'/' /usr/share/sddm/themes/sugar-candy/theme.conf
        echo "File theme.conf updated in /usr/share/sddm/themes/sugar-candy/"

    fi

elif [ "$dmsel" == "Deactivate current display manager" ] ;then

    sudo rm /etc/systemd/system/display-manager.service
    echo "Current display manager deactivated."
    disman=1

elif [ "$dmsel" == "Keep current setup" ] ;then
    echo "Keep current setup."
else
    echo "Keep current setup."
fi
