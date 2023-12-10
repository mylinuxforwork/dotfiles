#!/bin/bash

_settingsCustom() {
    clear
cat <<"EOF"
  ____          _                  
 / ___|   _ ___| |_ ___  _ __ ___  
| |  | | | / __| __/ _ \| '_ ` _ \ 
| |__| |_| \__ \ || (_) | | | | | |
 \____\__,_|___/\__\___/|_| |_| |_|
                                   
EOF
    echo "Press ESC to proceed."
    echo ""
    filevalue=$(gum write --show-line-numbers --height 15 --width 70 --value="$(cat ~/dotfiles/hypr/conf/custom.conf)")
    clear
cat <<"EOF"
  ____          _                  
 / ___|   _ ___| |_ ___  _ __ ___  
| |  | | | / __| __/ _ \| '_ ` _ \ 
| |__| |_| \__ \ || (_) | | | | | |
 \____\__,_|___/\__\___/|_| |_| |_|
                                   
EOF
    if gum confirm "Do you want to save your changes into ~/dotfiles/hypr/conf/custom.conf?" ;then
        echo "$filevalue" > ~/dotfiles/hypr/conf/custom.conf
    fi
    _settingsMenu
}

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
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
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
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
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
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
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
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/monitor.conf
    fi
    _settingsMenu
}

_settingsEnvironment() {
    clear
cat <<"EOF"
 _____            _                                      _   
| ____|_ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_ 
|  _| | '_ \ \ / / | '__/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
| |___| | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_ 
|_____|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|
                                                             
EOF

    cur=$(cat ~/dotfiles/hypr/conf/environment.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Please restart Hyprland after changing the environment."
    echo "If you select KVM it's recommended to shutdown your system and start again."
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/environments/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/environment.conf
    fi
    _settingsMenu
}

_settingsKeybinding() {
    clear
cat <<"EOF"
 _  __          _     _           _ _                 
| |/ /___ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___ 
| ' // _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
| . \  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \
|_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
          |___/                             |___/     

EOF
    cur=$(cat ~/dotfiles/hypr/conf/keybinding.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/keybindings/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/keybinding.conf
    fi
    _settingsMenu
}

_settingsWindowrule() {
    clear
cat <<"EOF"
__        ___           _                          _           
\ \      / (_)_ __   __| | _____      ___ __ _   _| | ___  ___ 
 \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / '__| | | | |/ _ \/ __|
  \ V  V / | | | | | (_| | (_) \ V  V /| |  | |_| | |  __/\__ \
   \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |_|   \__,_|_|\___||___/
                                                               
EOF

    cur=$(cat ~/dotfiles/hypr/conf/windowrule.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/windowrules/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/windowrule.conf
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
    if [ -f ~/dotfiles/version ] ;then
        echo "Version: $(cat ~/dotfiles/version)"
        echo ""
    fi
    menu=$(gum choose "Decorations" "Windows" "Animations" "Monitors" "Environments" "Keybindings" "Windowrules" "Custom" "EXIT")
    case $menu in
        Decorations)
            _settingsDecoration
        break;;
        Windows) 
            _settingsWindow
        break;;
        Animations) 
            _settingsAnimation
        break;;
        Monitors) 
            _settingsMonitor
        break;;
        Environments) 
            _settingsEnvironment
        break;;
        Keybindings) 
            _settingsKeybinding
        break;;
        Windowrules) 
            _settingsWindowrule
        break;;
        Custom) 
            _settingsCustom
        break;;
        * ) 
            exit
        ;;
    esac
}

_settingsMenu