# ------------------------------------------------------
# Restore
# ------------------------------------------------------

restorelist=""
monitorrestored=0

_showRestoreOptions() {
    echo "The following configurations can be transferred into the new installation."
    echo "(SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL)"
    echo ""
    restorelist=""
    if [ -f ~/dotfiles/.bashrc ]; then
        restorelist+="~/dotfiles/.bashrc "
    fi
    if [[ $profile == *"Hyprland"* ]]; then
        if [ -f ~/dotfiles/hypr/conf/keyboard.conf ]; then
            restorelist+="~/dotfiles/hypr/conf/keyboard.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/keybinding.conf ] && [ -d ~/dotfiles/hypr/conf/keybindings/ ]; then
            restorelist+="~/dotfiles/hypr/conf/keybinding.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/environment.conf ] && [ -d ~/dotfiles/hypr/conf/environments/ ]; then
            restorelist+="~/dotfiles/hypr/conf/environment.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/windowrule.conf ] && [ -d ~/dotfiles/hypr/conf/windowrules/ ]; then
            restorelist+="~/dotfiles/hypr/conf/windowrule.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/monitor.conf ] && [ -d ~/dotfiles/hypr/conf/monitors/ ]; then
            restorelist+="~/dotfiles/hypr/conf/monitor.conf "
            monitorrestored=1
        fi
        if [ -f ~/dotfiles/hypr/conf/animation.conf ] && [ -d ~/dotfiles/hypr/conf/animations/ ]; then
            restorelist+="~/dotfiles/hypr/conf/animation.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/decoration.conf ] && [ -d ~/dotfiles/hypr/conf/decorations/ ]; then
            restorelist+="~/dotfiles/hypr/conf/decoration.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/window.conf ] && [ -d ~/dotfiles/hypr/conf/windows/ ]; then
            restorelist+="~/dotfiles/hypr/conf/window.conf "
        fi
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [ -f ~/dotfiles/qtile/conf/keyboard.py ]; then
            restorelist+="~/dotfiles/qtile/conf/keyboard.py "
        fi
        if [ -f ~/dotfiles/qtile/autostart_wayland.sh ]; then
            restorelist+="~/dotfiles/qtile/autostart_wayland.sh "
        fi
        if [ -f ~/dotfiles/qtile/autostart_x11.sh ]; then
            restorelist+="~/dotfiles/qtile/autostart_x11.sh "
        fi
    fi
    if [ ! -z "$restorelist" ] ;then
        restorelist+="All"
    fi
    restoreselect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " $restorelist)
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
    if [[ $profile == *"Hyprland"* ]]; then
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
        if [[ $restoreselect == *"~/dotfiles/qtile/conf/keyboard.py"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/qtile/conf/keyboard.py ]; then
                cp ~/dotfiles/qtile/conf/keyboard.py ~/dotfiles-versions/$version/qtile/conf/
                echo "Qtile keyboard.py restored!"
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/qtile/autostart_wayland.sh"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/qtile/autostart_wayland.sh ]; then
                cp ~/dotfiles/qtile/autostart_wayland.sh ~/dotfiles-versions/$version/qtile/
                echo "Qtile autostart_wayland.sh restored!"
            fi
        fi
        if [[ $restoreselect == *"~/dotfiles/qtile/autostart_x11.sh"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/dotfiles/qtile/autostart_x11.sh ]; then
                cp ~/dotfiles/qtile/autostart_x11.sh ~/dotfiles-versions/$version/qtile/
                echo "Qtile autostart_x11.sh restored!"
            fi
        fi
    fi
    restored=1
    return 0
}

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
    echo "In that case, please use the automated backup or create your own backup manually."
    echo ""
    
    _showRestoreOptions
    
    echo ""
fi
