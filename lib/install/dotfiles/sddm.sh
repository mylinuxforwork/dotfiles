# ------------------------------------------------------
# Toggle SDDM
# ------------------------------------------------------
_writeLogHeader "SDDM"
_writeHeader "SDDM"

if [ -z $automation_displaymanager ] ;then
    if [ -f /etc/systemd/system/display-manager.service ]; then
        disman=0
        echo "You have already installed a display manager. If your display manager is working fine, you can keep the current setup."
        echo "How do you want to proceed?"
        echo
        dmsel=$(gum choose "Keep current setup" "Deactivate current display manager" "Install sddm")
    else
        disman=1
        echo "There is no display manager installed on your system. You're starting Hyprland with commands on tty."
        echo "How do you want to proceed?"
        echo
        dmsel=$(gum choose "Keep current setup" "Install sddm")
    fi

    if [ -z "${dmsel}" ] ;then
        echo ":: Installation canceled."
        exit
    fi

    if [ "$dmsel" == "Install sddm" ] ;then

        disman=0
        # Try to force the installation of sddm
        echo ":: Installing sddm"
        sudo pacman -S --noconfirm --needed sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg --ask 4
        
        # Enable sddm
        if [ -f /etc/systemd/system/display-manager.service ]; then
            sudo rm /etc/systemd/system/display-manager.service
        fi
        sudo systemctl enable sddm.service
        echo 

    elif [ "$dmsel" == "Deactivate current display manager" ] ;then

        sudo rm /etc/systemd/system/display-manager.service
        echo ":: Current display manager deactivated."
        disman=1

    elif [ "$dmsel" == "Keep current setup" ] ;then

        echo ":: sddm setup skipped."

    else

        echo ":: sddm setup skipped."

    fi
else
    if [[ "$automation_displaymanager" = true ]] ;then
        echo ":: AUTOMATION: Keep current setup of Display Manager"
        disman=0
    fi
fi