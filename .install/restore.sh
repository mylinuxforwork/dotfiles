# ------------------------------------------------------
# Restore
# ------------------------------------------------------

restorelist=""
selectedlist=""
monitorrestored=0

_showRestoreOptions() {
    echo "The following configurations can be transferred into the new installation."
    echo "(SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL)"
    echo ""
    restorelist=""
    if [ -f ~/dotfiles/.bashrc ]; then
        restorelist+="~/dotfiles/.bashrc "
        selectedlist+="~/dotfiles/.bashrc,"
    fi
    if [ -d ~/dotfiles/.settings ]; then
        restorelist+="~/dotfiles/.settings "
        selectedlist+="~/dotfiles/.settings,"
    fi
    if [[ $profile == *"Hyprland"* ]]; then
        if [ -f ~/dotfiles/hypr/conf/custom.conf ]; then
            restorelist+="~/dotfiles/hypr/conf/custom.conf "
            selectedlist+="~/dotfiles/hypr/conf/custom.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/keyboard.conf ]; then
            restorelist+="~/dotfiles/hypr/conf/keyboard.conf "
            selectedlist+="~/dotfiles/hypr/conf/keyboard.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/keybinding.conf ] && [ -d ~/dotfiles/hypr/conf/keybindings/ ]; then
            restorelist+="~/dotfiles/hypr/conf/keybinding.conf "
            selectedlist+="~/dotfiles/hypr/conf/keybinding.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/environment.conf ] && [ -d ~/dotfiles/hypr/conf/environments/ ]; then
            restorelist+="~/dotfiles/hypr/conf/environment.conf "
            selectedlist+="~/dotfiles/hypr/conf/environment.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/windowrule.conf ] && [ -d ~/dotfiles/hypr/conf/windowrules/ ]; then
            restorelist+="~/dotfiles/hypr/conf/windowrule.conf "
            selectedlist+="~/dotfiles/hypr/conf/windowrule.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/monitor.conf ] && [ -d ~/dotfiles/hypr/conf/monitors/ ]; then
            restorelist+="~/dotfiles/hypr/conf/monitor.conf "
            selectedlist+="~/dotfiles/hypr/conf/monitor.conf,"
            monitorrestored=1
        fi
        if [ -f ~/dotfiles/hypr/conf/animation.conf ] && [ -d ~/dotfiles/hypr/conf/animations/ ]; then
            restorelist+="~/dotfiles/hypr/conf/animation.conf "
            selectedlist+="~/dotfiles/hypr/conf/animation.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/decoration.conf ] && [ -d ~/dotfiles/hypr/conf/decorations/ ]; then
            restorelist+="~/dotfiles/hypr/conf/decoration.conf "
            selectedlist+="~/dotfiles/hypr/conf/decoration.conf,"
        fi
        if [ -f ~/dotfiles/hypr/conf/window.conf ] && [ -d ~/dotfiles/hypr/conf/windows/ ]; then
            restorelist+="~/dotfiles/hypr/conf/window.conf "
            selectedlist+="~/dotfiles/hypr/conf/window.conf,"
        fi
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [ -f ~/dotfiles/qtile/autostart.sh ]; then
            restorelist+="~/dotfiles/qtile/autostart.sh "
            selectedlist+="~/dotfiles/qtile/autostart.sh,"
        fi
    fi
    restoreselect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedlist" $restorelist)
    if [ ! -z "$restoreselect" ] ;then
        echo "Selected to restore:" 
        echo "$restoreselect"
        echo ""
        confirmrestore=$(gum choose "Start restore" "Change restore" "Cancel restore")
        if [ "$confirmrestore" == "Start restore" ] ;then
            _startRestore
        elif [ "$confirmrestore" == "Change restore" ]; then 
            _showRestoreOptions
        else
            echo "Restore skipped."
            return 0
        fi
    else
        echo "No files selected to restore."
        confirmrestore=$(gum choose "Change restore" "Cancel restore")
        if [ "$confirmrestore" == "Change restore" ]; then 
            echo ""
            _showRestoreOptions
        else
            echo "Restore skipped."
            return 0
        fi
    fi
}

_startRestore() {
    if [[ $restoreselect == *"~/dotfiles/.bashrc"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/dotfiles/.bashrc ]; then
            cp ~/dotfiles/.bashrc ~/dotfiles-versions/$version/
            echo ".bashrc restored!"
        fi
    fi
    if [[ $restoreselect == *"~/dotfiles/.settings"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -d ~/dotfiles/.settings ]; then
            rsync -a -I ~/dotfiles/.settings/ ~/dotfiles-versions/$version/.settings/
            echo ".settings restored!"
        fi
    fi
    if [[ $profile == *"Hyprland"* ]]; then
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/custom.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/custom.conf ]; then
                cp ~/dotfiles/hypr/conf/custom.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland custom.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/keyboard.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/keyboard.conf ]; then
                cp ~/dotfiles/hypr/conf/keyboard.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland keyboard.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/monitor.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/monitor.conf ]; then
                cp ~/dotfiles/hypr/conf/monitor.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland monitor.conf restored!"                
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/keybinding.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/keybinding.conf ]; then
                cp ~/dotfiles/hypr/conf/keybinding.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland keybinding.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/environment.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/environment.conf ]; then
                cp ~/dotfiles/hypr/conf/environment.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland environment.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/windowrule.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/windowrule.conf ]; then
                cp ~/dotfiles/hypr/conf/windowrule.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland windowrule.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/animation.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/animation.conf ]; then
                cp ~/dotfiles/hypr/conf/animation.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland animation.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/decoration.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/decoration.conf ]; then
                cp ~/dotfiles/hypr/conf/decoration.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland decoration.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/hypr/conf/window.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/hypr/conf/window.conf ]; then
                cp ~/dotfiles/hypr/conf/window.conf ~/dotfiles-versions/$version/hypr/conf/
                echo "Hyprland window.conf restored!"
            fi
        fi
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [[ $restoreselect == *"~/dotfiles/qtile/autostart.sh"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/qtile/autostart.sh ]; then
                cp ~/dotfiles/qtile/autostart.sh ~/dotfiles-versions/$version/qtile/
                echo "Qtile autostart.sh restored!"
            fi
        fi
    fi
    restored=1
    return 0
}

if [ -d ~/dotfiles ]; then

echo -e "${GREEN}"
figlet "Restore"
echo -e "${NONE}"
    restored=0
    echo "The script will try to restore existing configurations."
    echo "PLEASE NOTE: Restoring is not possible with version < 2.6 of the dotfiles."
    echo "In that case, please use the automated backup or create your own backup manually."
    echo ""
    
    _showRestoreOptions

    # Restore Waybar Workspaces
    targetFile="$HOME/dotfiles-versions/$version/waybar/modules.json"
    settingsFile="$HOME/dotfiles/.settings/waybar_workspaces"
    if [ -f $settingsFile ] ;then
        startMarker="START WORKSPACE"
        endMarker="END WORKSPACES"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile"
        echo "Waybar Workspaces restored."
    fi

    # Restore Waybar Appslabel
    targetFile="$HOME/dotfiles-versions/$version/waybar/modules.json"
    settingsFile="$HOME/dotfiles/.settings/waybar_appslabel"
    if [ -f $settingsFile ] ;then
        startMarker="START APPS LABEL"
        endMarker="END APPS LABEL"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile"
        echo "Waybar Appslabel restored."
    fi

    # Restore Waybar ChatGPT
    targetFile="$HOME/dotfiles/waybar/modules.json"
    settingsFile="$HOME/dotfiles/.settings/waybar_chatgpt"
    if [ -f $settingsFile ] ;then
        startMarker="START CHATGPT TOOGLE"
        endMarker="END CHATGPT TOOGLE"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile"
        echo "Waybar ChatGPT restored."
    fi

    # Restore Waybar Bluetooth
    targetFile1="$HOME/dotfiles-versions/$version/waybar/themes/ml4w/config"
    targetFile2="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-blur/config"
    targetFile3="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-blur-bottom/config"
    targetFile4="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-bottom/config"
    settingsFile="$HOME/dotfiles/.settings/waybar_bluetooth"
    if [ -f $settingsFile ] ;then
        startMarker="START BT TOOGLE"
        endMarker="END BT TOOGLE"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile1"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile2"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile3"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile4"
        echo "Waybar Bluetooth restored."
    fi

    # Restore Waybar Systray
    targetFile1="$HOME/dotfiles-versions/$version/waybar/themes/ml4w/config"
    targetFile2="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-blur/config"
    targetFile3="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-blur-bottom/config"
    targetFile4="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-bottom/config"
    settingsFile="$HOME/dotfiles/.settings/waybar_systray"
    if [ -f $settingsFile ] ;then
        startMarker="START TRAY TOOGLE"
        endMarker="END TRAY TOOGLE"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile1"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile2"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile3"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile4"
        echo "Waybar Systray restored."
    fi

    # Restore Waybar Network
    targetFile1="$HOME/dotfiles-versions/$version/waybar/themes/ml4w/config"
    targetFile2="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-blur/config"
    targetFile3="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-blur-bottom/config"
    targetFile4="$HOME/dotfiles-versions/$version/waybar/themes/ml4w-bottom/config"
    settingsFile="$HOME/dotfiles/.settings/waybar_network"
    if [ -f $settingsFile ] ;then
        startMarker="START NETWORK TOOGLE"
        endMarker="END NETWORK TOOGLE"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile1"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile2"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile3"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile4"
        echo "Waybar Network restored."
    fi

    # Restore Waybar nmapplet
    targetFile="$HOME/dotfiles-versions/$version/hypr/conf/autostart.conf"
    settingsFile="$HOME/dotfiles/.settings/waybar_nmapplet"
    if [ -f $settingsFile ] ;then
        startMarker="START NM APPLET"
        endMarker="END NM APPLET"
        customtext="$(cat $settingsFile)"
        _replaceInFile "$startMarker" "$endMarker" "$customtext" "$targetFile"
        echo "nm-applet restored."
    fi

    # Restore Keyboard natural_scroll
    targetFile="$HOME/dotfiles-versions/$version/hypr/conf/keyboard.conf"
    settingsFile="$HOME/dotfiles/.settings/keyboard_naturalscroll"
    if [ -f $settingsFile ] ;then
        findMarker="natural_scroll"
        customtext="$(cat $settingsFile)"
        _replaceLineInFile "$findMarker" "$customtext" "$targetFile"
        echo "keyboard natural_scroll restored."
    fi

    echo ""
fi
