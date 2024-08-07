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
    if [ -f ~/$dot_folder/.bashrc ]; then
        restorelist+="~/$dot_folder/.bashrc "
        selectedlist+="~/$dot_folder/.bashrc,"
    fi
    if [ -d ~/dotfiles/.settings ]; then
        restorelist+="~/$dot_folder/.config/ml4w/settings "
        selectedlist+="~/$dot_folder/.config/ml4w/settings,"
    fi
    if [[ $profile == *"Hyprland"* ]]; then
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
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [ -f ~/$dot_folder/.config/qtile/autostart.sh ]; then
            restorelist+="~/$dot_folder/.config/qtile/autostart.sh "
            selectedlist+="~/$dot_folder/.config/qtile/autostart.sh,"
        fi
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

_startRestore() {
    if [[ $restoreselect == *"~/$dot_folder/.bashrc"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/$dot_folder/.bashrc ]; then
            cp ~/$dot_folder/.bashrc ~/dotfiles-versions/$version/
            echo ":: .bashrc restored!"
        fi
    fi
    if [[ $restoreselect == *"~/$dot_folder/.config/ml4w/settings"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -d ~/$dot_folder/.config/ml4w/settings ]; then
            rsync -avhp -I ~/$dot_folder/.config/ml4w/settings/ ~/dotfiles-versions/$version/.config/ml4w/settings/
            echo ":: settings restored!"
        fi
    fi
    if [[ $profile == *"Hyprland"* ]]; then
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/hypridle.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/hypridle.conf ]; then
                cp ~/$dot_folder/.config/hypr/hypridle.conf ~/dotfiles-versions/$version/.config/hypr/
                echo ":: Hyprland hypridle.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/custom.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/custom.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/custom.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                echo ":: Hyprland custom.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/keyboard.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/keyboard.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/keyboard.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                echo ":: Hyprland keyboard.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/monitor.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/monitor.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/monitor.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/monitor.conf
                echo ":: Hyprland monitor.conf restored!"                
            fi
        fi
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/keybinding.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/keybinding.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/keybinding.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/keybinding.conf
                echo ":: Hyprland keybinding.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/environment.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/environment.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/environment.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/environment.conf
                echo ":: Hyprland environment.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/layout.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/layout.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/layout.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/layout.conf
                echo ":: Hyprland layout.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/windowrule.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/windowrule.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/windowrule.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/windowrule.conf
                echo ":: Hyprland windowrule.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/animation.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/animation.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/animation.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/animation.conf
                echo ":: Hyprland animation.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/decoration.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/decoration.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/decoration.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/decoration.conf
                echo ":: Hyprland decoration.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/$dot_folder/.config/hypr/conf/window.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/hypr/conf/window.conf ]; then
                cp ~/$dot_folder/.config/hypr/conf/window.conf ~/dotfiles-versions/$version/.config/hypr/conf/
                sed -i -e 's/dotfiles/.config/g' ~/dotfiles-versions/$version/.config/hypr/conf/window.conf
                echo ":: Hyprland window.conf restored!"
            fi
        fi

        # Check Wallpaper
        if [ -f ~/.config/ml4w/cache/blurred_wallpaper.png ] ;then
            rm ~/dotfiles-versions/$version/.config/ml4w/cache/blurred_wallpaper.png
        fi
        if [ -f ~/.config/ml4w/cache/current_wallpaper ] ;then
            rm ~/dotfiles-versions/$version/.config/ml4w/cache/current_wallpaper
        fi
        if [ -f ~/.config/ml4w/cache/current_wallpaper.rasi ] ;then
            rm ~/dotfiles-versions/$version/.config/ml4w/cache/current_wallpaper.rasi
        fi
        if [ -f ~/.config/ml4w/cache/square_wallpaper.png ] ;then
            rm ~/dotfiles-versions/$version/.config/ml4w/cache/square_wallpaper.png
        fi
        if [ -f ~/.config/hypr/hyprpaper.conf ] ;then
            rm ~/dotfiles-versions/$version/.config/hypr/hyprpaper.conf
        fi

    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [[ $restoreselect == *"~/$dot_folder/.config/qtile/autostart.sh"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/$dot_folder/.config/qtile/autostart.sh ]; then
                cp ~/$dot_folder/.config/qtile/autostart.sh ~/dotfiles-versions/$version/.config/qtile/
                echo ":: Qtile autostart.sh restored!"
            fi
        fi
    fi
    restored=1
    return 0
}

if [ -d ~/$dot_folder ]; then
    echo -e "${GREEN}"
    figlet "Restore"
    echo -e "${NONE}"
        restored=0
        echo "The script will try to restore existing configurations."
        echo ""
        _showRestoreOptions
        echo ""
fi
