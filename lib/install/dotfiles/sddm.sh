# ------------------------------------------------------
# Toggle SDDM
# ------------------------------------------------------
_writeLogHeader "SDDM"
_writeHeader "SDDM"

current_display_manager=""

_detectCurrentDisplayManager() {
    if [ -f /etc/systemd/system/display-manager.service ]; then
        execstart=$(grep 'ExecStart=' /etc/systemd/system/display-manager.service)
        arrIN=(${execstart//\// })
        for i in "${arrIN[@]}"; do
            current_display_manager=$i
        done
    fi
}

_enterDisplayManager() {
    _writeMessage "Enter the name of your the display manager manually (e.g., gdm)"
    current_display_manager=$(gum input)
}

_confirmCurrentDisplayManager() {
    _detectCurrentDisplayManager
    if [ ! -z $current_display_manager ]; then
        _writeLogTerminal 0 "The script has detected $current_display_manager as your current display manager"
        if gum confirm "Is this correct"; then
            _writeLogTerminal 1 "$current_disyplay_manager confirmed"
        else
            _enterDisplayManager
        fi
    fi
}

_installSDDM() {

    _writeLog 0 "Installing sddm"
    source $packages_directory/$install_platform/sddm.sh
    _installPackages "${packages[@]}"

    sudo systemctl disable $current_display_manager
    sudo systemctl enable sddm

}

_disableDisplayManager() {
    sudo systemctl disable $current_display_manager
    _writeLog 0 "Current display manager deactivated."
}

if [ -z $automation_displaymanager ]; then
    _detectCurrentDisplayManager

    if [ -f /etc/systemd/system/display-manager.service ]; then
        disman=0
        _writeLogTerminal 0 "You have already installed a display manager."
        _writeMessage "If your display manager is working fine, you can keep the current setup."
        echo
        dmsel=$(gum choose "Keep current setup" "Deactivate current display manager" "Install sddm")
    else
        disman=1
        _writeLogTerminal 0 "There is no display manager installed on your system."
        _writeMessage "You're starting Hyprland with commands on tty."
        echo
        dmsel=$(gum choose "Keep current setup" "Install sddm")
    fi

    if [ -z "${dmsel}" ]; then
        _writeCancel
        exit
    fi

    if [ "$dmsel" == "Install sddm" ]; then
        _confirmCurrentDisplayManager
        _installSDDM
    elif [ "$dmsel" == "Deactivate current display manager" ]; then
        _disableDisplayManager
    elif [ "$dmsel" == "Keep current setup" ]; then
        _writeSkipped
    else
        _writeSkipped
    fi
else
    if [[ "$automation_displaymanager" = true ]]; then
        _writeLogTerminal 0 "AUTOMATION: Keep current setup of Display Manager"
        disman=0
    fi
fi
