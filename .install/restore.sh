# ------------------------------------------------------
# Restore
# ------------------------------------------------------

restorelist=""

_showRestoreOptions() {
    echo "The following configurations can be transferred into the new installation:"
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
        if [ -f ~/dotfiles/hypr/conf/keybindings.conf ]; then
            restorelist+="~/dotfiles/hypr/conf/keybindings.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/monitor.conf ] && [ -d ~/dotfiles/hypr/conf/monitor/ ]; then
            restorelist+="~/dotfiles/hypr/conf/monitor.conf "
        fi
        if [ -f ~/dotfiles/hypr/conf/animation.conf ] && [ -d ~/dotfiles/hypr/conf/animation/ ]; then
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
    fi
    if [ ! -z "$restorelist" ] ;then
        restorelist+="All"
    fi
    restoreselect=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " $restorelist)
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
        cp ~/dotfiles/.bashrc ~/dotfiles-versions/$version/
        echo ".bashrc restored!"
    fi
    if [[ $restoreselect == *"~/dotfiles/hypr/conf/keyboard.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/hypr/conf/keyboard.conf ~/dotfiles-versions/$version/hypr/conf/
        echo "Hyprland keyboard.conf restored!"
    fi
    if [[ $restoreselect == *"~/dotfiles/hypr/conf/monitor.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/hypr/conf/monitor.conf ~/dotfiles-versions/$version/hypr/conf/
        echo "Hyprland monitor.conf restored!"                
    fi
    if [[ $restoreselect == *"~/dotfiles/hypr/conf/keybindings.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/hypr/conf/keybindings.conf ~/dotfiles-versions/$version/hypr/conf/
        echo "Hyprland keybindings.conf restored!"
    fi
    if [[ $restoreselect == *"~/dotfiles/hypr/conf/animation.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/hypr/conf/animation.conf ~/dotfiles-versions/$version/hypr/conf/
        echo "Hyprland animation.conf restored!"
    fi
    if [[ $restoreselect == *"~/dotfiles/hypr/conf/decoration.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/hypr/conf/decoration.conf ~/dotfiles-versions/$version/hypr/conf/
        echo "Hyprland decoration.conf restored!"
    fi
    if [[ $restoreselect == *"~/dotfiles/hypr/conf/window.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/hypr/conf/window.conf ~/dotfiles-versions/$version/hypr/conf/
        echo "Hyprland keybindings.conf restored!"
    fi
    if [[ $restoreselect == *"~/dotfiles/qtile/conf/keyboard.py"* ]] || [[ $restoreselect == *"All"* ]] ; then
        cp ~/dotfiles/qtile/conf/keyboard.py ~/dotfiles-versions/$version/qtile/conf/
        echo "Qtile keyboard.py restored!"
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