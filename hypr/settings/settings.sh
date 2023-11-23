#!/bin/sh
_settingsDecoration() {
    clear
cat <<"EOF"
 ____                           _   _                 
|  _ \  ___  ___ ___  _ __ __ _| |_(_) ___  _ __  ___ 
| | | |/ _ \/ __/ _ \| '__/ _` | __| |/ _ \| '_ \/ __|
| |_| |  __/ (_| (_) | | | (_| | |_| | (_) | | | \__ \
|____/ \___|\___\___/|_|  \__,_|\__|_|\___/|_| |_|___/
                                                      
EOF
    cur=$(cat ~/dotfiles/hypr/conf/decoration.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/decorations/)
    if [ ! -z $sel ] ;then
        echo "source = $sel" > ~/dotfiles/hypr/conf/decoration.conf
        _settingsDecoration
    fi
    _settingsMenu
}

_settingsWindow() {
    clear
cat <<"EOF"
__        ___           _                   
\ \      / (_)_ __   __| | _____      _____ 
 \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / __|
  \ V  V / | | | | | (_| | (_) \ V  V /\__ \
   \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |___/
                                            
EOF
    cur=$(cat ~/dotfiles/hypr/conf/window.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/windows/)
    if [ ! -z $sel ] ;then
        echo "source = $sel" > ~/dotfiles/hypr/conf/window.conf
        _settingsWindow
    fi
    _settingsMenu
}

_settingsAnimation() {
    clear
cat <<"EOF"
    _          _                 _   _                 
   / \   _ __ (_)_ __ ___   __ _| |_(_) ___  _ __  ___ 
  / _ \ | '_ \| | '_ ` _ \ / _` | __| |/ _ \| '_ \/ __|
 / ___ \| | | | | | | | | | (_| | |_| | (_) | | | \__ \
/_/   \_\_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_|___/
                                                       
EOF
    cur=$(cat ~/dotfiles/hypr/conf/animation.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/animations/)
    if [ ! -z $sel ] ;then
        echo "source = $sel" > ~/dotfiles/hypr/conf/animation.conf
        _settingsAnimation
    fi
    _settingsMenu
}

_settingsMonitor() {
    clear
cat <<"EOF"
 __  __             _ _             
|  \/  | ___  _ __ (_) |_ ___  _ __ 
| |\/| |/ _ \| '_ \| | __/ _ \| '__|
| |  | | (_) | | | | | || (_) | |   
|_|  |_|\___/|_| |_|_|\__\___/|_|   
                                    
EOF
    cur=$(cat ~/dotfiles/hypr/conf/monitor.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/monitors/)
    if [ ! -z $sel ] ;then
        echo "source = $sel" > ~/dotfiles/hypr/conf/monitor.conf
    fi
    _settingsMenu
}

_settingsMenu() {
    clear
cat <<"EOF"
 ____       _   _   _                 
/ ___|  ___| |_| |_(_)_ __   __ _ ___ 
\___ \ / _ \ __| __| | '_ \ / _` / __|
 ___) |  __/ |_| |_| | | | | (_| \__ \
|____/ \___|\__|\__|_|_| |_|\__, |___/
                            |___/     

EOF
    menu=$(gum choose "Decorations" "Windows" "Animations" "Monitors" "EXIT")
    case $menu in
        [Decorations]* )
            _settingsDecoration
        break;;
        [Windows]* ) 
            _settingsWindow
        break;;
        [Animations]* ) 
            _settingsAnimation
        break;;
        [Monitors]* ) 
            _settingsMonitor
        break;;
        * ) 
            exit
        ;;
    esac
}

_settingsMenu


