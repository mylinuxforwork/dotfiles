# ------------------------------------------------------
# Restore
# ------------------------------------------------------
_writeLogHeader "Restore"

restorelist=""
selectedlist=""
monitorrestored=0

restore_arr=(
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".gtkrc-2.0"
    ".config/ml4w/settings"
    ".config/hypr/hypridle.conf"
    ".config/hypr/conf/custom.conf"
    ".config/hypr/conf/keyboard.conf"
    ".config/hypr/conf/keybinding.conf"
    ".config/hypr/conf/environment.conf"
    ".config/hypr/conf/layout.conf"
    ".config/hypr/conf/windowrule.conf"
    ".config/hypr/conf/monitor.conf"
    ".config/hypr/conf/animation.conf"
    ".config/hypr/conf/decoration.conf"
    ".config/hypr/conf/window.conf"
)

_writeToRestoreList() {
    if [ -d $HOME/$dot_folder/$1 ]; then
        restorelist+="$1 "
        selectedlist+="$1,"
    elif [ -f $HOME/$dot_folder/$1 ]; then
        restorelist+="$1 "
        selectedlist+="$1,"
    fi
}

_restoreItem() {
    if [[ $restoreselect == *"$1"* ]]; then
        if [ -d $HOME/$dot_folder/$1 ]; then
            _writeLog 0 "Restore Folder $1"
            rsync -a -I $HOME/$dot_folder/$1/ $ml4w_directory/$version/$1/ &>> $(_getLogFile)
        elif [ -f $HOME/$dot_folder/$1 ]; then
            _writeLog 0 "Restore File $1"
            cp $HOME/$dot_folder/$1 $ml4w_directory/$version/$1
        fi
        _writeLog 1 "Hyprland $1 restored"
    fi
}

_showRestoreOptions() {
    _writeMessage "The following configurations can be transferred into the new installation."
    echo
    restorelist=""

    for item in "${restore_arr[@]}"
    do
        _writeToRestoreList "$item"
    done 

    restoreselect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedlist" $restorelist)
    if [ ! -z "$restoreselect" ]; then
        echo "Selected to restore:" 
        echo "$restoreselect"
        echo ""
        confirmrestore=$(gum choose "Start restore" "Change restore" "Skip restore")
        if [ "$confirmrestore" == "Start restore" ]; then
            _startRestore
        elif [ "$confirmrestore" == "Change restore" ]; then 
            _showRestoreOptions
        else
            _writeSkipped
            return 0
        fi
    else
        echo "No files selected to restore."
        confirmrestore=$(gum choose "Change restore" "Skip restore")
        if [ -z "${confirmrestore}" ]; then
            _writeCancel
            exit
        fi
        if [ "$confirmrestore" == "Change restore" ]; then 
            echo ""
            _showRestoreOptions
        else
            _writeSkipped
            return 0
        fi
    fi
}

_restore_automation() {
    for item in "${restore_arr[@]}"
    do
        restoreselect+="$item "
    done
    _startRestore
}

_startRestore() {

    for item in "${restore_arr[@]}"
    do
        _restoreItem "$item"
    done

    restored=1
    return 0
}

if [ -d $HOME/$dot_folder ]; then
    _writeHeader "Restore"
    restored=0
    _writeMessage "The script will try to restore existing configurations."
    echo
    if [ -z $automation_restore ]; then
        _showRestoreOptions
    else
        if [[ "$automation_restore" = true ]]; then
            _restore_automation
        fi
    fi
    echo
fi
