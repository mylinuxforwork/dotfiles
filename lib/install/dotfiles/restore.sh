# ------------------------------------------------------
# Restore
# ------------------------------------------------------

restorelist=""
selectedlist=""
monitorrestored=0

_showRestoreOptions() {
    echo "The following configurations can be transferred into the new installation."
    echo
    restorelist=""
    if [ -d ~/$dot_folder/.config/ml4w/settings ]; then
        restorelist+="~/$dot_folder/.config/ml4w/settings "
        selectedlist+="~/$dot_folder/.config/ml4w/settings,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/hypridle.conf ]; then
        restorelist+="~/$dot_folder/.config/hypr/hypridle.conf "
        selectedlist+="~/$dot_folder/.config/hypr/hypridle.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/custom.conf ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/custom.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/custom.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/keyboard.conf ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/keyboard.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/keyboard.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/keybinding.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/keybindings/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/keybinding.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/keybinding.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/environment.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/environments/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/environment.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/environment.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/layout.conf ] && [ -d ~$dot_folder/.config/hypr/conf/layouts/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/layout.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/layout.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/windowrule.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/windowrules/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/windowrule.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/windowrule.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/monitor.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/monitors/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/monitor.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/monitor.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/animation.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/animations/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/animation.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/animation.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/decoration.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/decorations/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/decoration.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/decoration.conf,"
    fi
    if [ -f ~/$dot_folder/.config/hypr/conf/window.conf ] && [ -d ~/$dot_folder/.config/hypr/conf/windows/ ]; then
        restorelist+="~/$dot_folder/.config/hypr/conf/window.conf "
        selectedlist+="~/$dot_folder/.config/hypr/conf/window.conf,"
    fi
    restoreselect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedlist" $restorelist)
    if [ ! -z "$restoreselect" ] ;then
        echo "Selected to restore:" 
        echo "$restoreselect"
        echo ""
        confirmrestore=$(gum choose "Start restore" "Change restore" "Skip restore")
        if [ "$confirmrestore" == "Start restore" ] ;then
            _startRestore
        elif [ "$confirmrestore" == "Change restore" ]; then 
            _showRestoreOptions
        else
            echo ":: Restore skipped."
            return 0
        fi
    else
        echo "No files selected to restore."
        confirmrestore=$(gum choose "Change restore" "Skip restore")
        if [ -z "${confirmrestore}" ] ;then
            echo ":: Installation canceled."
            exit
        fi
        if [ "$confirmrestore" == "Change restore" ]; then 
            echo ""
            _showRestoreOptions
        else
            echo ":: Restore skipped."
            return 0
        fi
    fi
}

_restore_automation() {
    restoreselect="All"
    _startRestore
}

_startRestore() {
    if [[ $restoreselect == *"~/$dot_folder/.config/ml4w/settings"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -d ~/$dot_folder/.config/ml4w/settings ]; then
            rsync -avhp -I ~/$dot_folder/.config/ml4w/settings/ $ml4w_directory/$version/.config/ml4w/settings/
            echo ":: settings restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/hypridle.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/hypridle.conf ]; then
            cp ~/$dot_folder/.config/hypr/hypridle.conf $ml4w_directory/$version/.config/hypr/
            echo ":: Hyprland hypridle.conf restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/custom.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/custom.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/custom.conf $ml4w_directory/$version/.config/hypr/conf/
            echo ":: Hyprland custom.conf restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/keyboard.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/keyboard.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/keyboard.conf $ml4w_directory/$version/.config/hypr/conf/
            echo ":: Hyprland keyboard.conf restored!"
        fi
    fi        
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/monitor.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/monitor.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/monitor.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/monitor.conf
            echo ":: Hyprland monitor.conf restored!"                
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/keybinding.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/keybinding.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/keybinding.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/keybinding.conf
            echo ":: Hyprland keybinding.conf restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/environment.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/environment.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/environment.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/environment.conf
            echo ":: Hyprland environment.conf restored!"
        fi
    fi        
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/layout.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/layout.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/layout.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/layout.conf
            echo ":: Hyprland layout.conf restored!"
        fi
    fi        
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/windowrule.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/windowrule.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/windowrule.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/windowrule.conf
            echo ":: Hyprland windowrule.conf restored!"
        fi
    fi        
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/animation.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/animation.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/animation.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/animation.conf
            echo ":: Hyprland animation.conf restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/decoration.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/decoration.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/decoration.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/decoration.conf
            echo ":: Hyprland decoration.conf restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/window.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.config/hypr/conf/window.conf ]; then
            cp ~/$dot_folder/.config/hypr/conf/window.conf $ml4w_directory/$version/.config/hypr/conf/
            sed -i -e 's/dotfiles/.config/g' $ml4w_directory/$version/.config/hypr/conf/window.conf
            echo ":: Hyprland window.conf restored!"
        fi
    fi

    # Check Wallpaper
    if [ -f ~/.config/ml4w/cache/blurred_wallpaper.png ] ;then
        rm $ml4w_directory/$version/.config/ml4w/cache/blurred_wallpaper.png
    elif [ -f ~/.cache/blurred_wallpaper.png ] ;then
        cp ~/.cache/blurred_wallpaper.png $ml4w_directory/$version/.config/ml4w/cache/blurred_wallpaper.png
    fi

    if [ -f ~/.config/ml4w/cache/current_wallpaper ] ;then
        rm $ml4w_directory/$version/.config/ml4w/cache/current_wallpaper
    elif [ -f ~/.cache/current_wallpaper ] ;then
        cp ~/.cache/current_wallpaper $ml4w_directory/$version/.config/ml4w/cache/current_wallpaper
    fi
    
    if [ -f ~/.config/ml4w/cache/current_wallpaper.rasi ] ;then
        rm $ml4w_directory/$version/.config/ml4w/cache/current_wallpaper.rasi
    elif [ -f ~/.cache/current_wallpaper.rasi ] ;then
        cp ~/.cache/current_wallpaper.rasi $ml4w_directory/$version/.config/ml4w/cache/current_wallpaper.rasi
    fi
    
    if [ -f ~/.config/ml4w/cache/square_wallpaper.png ] ;then
        rm $ml4w_directory/$version/.config/ml4w/cache/square_wallpaper.png
    elif [ -f ~/.cache/square_wallpaper.png ] ;then
        cp ~/.cache/square_wallpaper.png $ml4w_directory/$version/.config/ml4w/cache/square_wallpaper.png
    fi
    
    restored=1
    return 0
}

if [ -d ~/$dot_folder ]; then
    echo -e "${GREEN}"
    figlet -f smslant "Restore"
    echo -e "${NONE}"
        restored=0
        echo "The script will try to restore existing configurations."
        echo ""
        if [ -z $automation_restore ] ;then
            _showRestoreOptions
        else
            if [[ "$automation_restore" = true ]] ;then
                _restore_automation
            fi
        fi
        echo
fi
