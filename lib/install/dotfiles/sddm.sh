# ------------------------------------------------------
# Toggle SDDM
# ------------------------------------------------------
_writeLogHeader "SDDM"
_writeHeader "SDDM"

if [ -z $automation_displaymanager ] ;then
    if [ -f /etc/systemd/system/display-manager.service ]; then
        disman=0
        _writeLogTerminal 0 "You have already installed a display manager."
        _writeMessage "If your display manager is working fine, you can keep the current setup."
        echo
        dmsel=$(gum choose "Keep current setup" "Deactivate current display manager" "Install sddm")
    else
        disman=1
        _writeLogTerminal 0 "There is no display manager installed on your system." 
        _writeLogMessage "You're starting Hyprland with commands on tty."
        echo
        dmsel=$(gum choose "Keep current setup" "Install sddm")
    fi

    if [ -z "${dmsel}" ] ;then
        _writeCancel
        exit
    fi

    if [ "$dmsel" == "Install sddm" ] ;then

        disman=0
        # Try to force the installation of sddm
        _writeLog 0 "Installing sddm"
        sudo pacman -S --noconfirm --needed sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg --ask 4
        
        # Enable sddm
        if [ -f /etc/systemd/system/display-manager.service ]; then
            sudo rm /etc/systemd/system/display-manager.service
        fi
        sudo systemctl enable sddm.service
        echo 

    elif [ "$dmsel" == "Deactivate current display manager" ] ;then

        sudo rm /etc/systemd/system/display-manager.service
        _writeLog 0 "Current display manager deactivated."
        disman=1

    elif [ "$dmsel" == "Keep current setup" ] ;then

        _writeSkipped

    else

        _writeSkipped

    fi
else
    if [[ "$automation_displaymanager" = true ]] ;then
        _writeLog 1 "AUTOMATION: Keep current setup of Display Manager"
        disman=0
    fi
fi