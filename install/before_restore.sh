# ------------------------------------------------------
# Modify existing files before restore starts
# ------------------------------------------------------

if [ -d ~/dotfiles ] ;then
    echo ":: Modify existing files"
    if [ ! -d ~/dotfiles/.config ] ;then
        mkdir ~/dotfiles/.config
    fi
    if [ ! -d ~/dotfiles/.config/ml4w ] ;then
        mkdir ~/dotfiles/.config/ml4w
    fi

    # ml4w folder
    _move_folder ~/dotfiles/.settings ~/dotfiles/.config/ml4w/settings
    _move_folder ~/dotfiles/scripts ~/dotfiles/.config/ml4w/scripts
    _move_folder ~/dotfiles/.version  ~/dotfiles/.config/ml4w/version
    _move_folder ~/dotfiles/apps ~/dotfiles/.config/ml4w/apps
    _move_folder ~/dotfiles/login ~/dotfiles/.config/ml4w/login
    _move_folder ~/dotfiles/sddm ~/dotfiles/.config/ml4w/sddm
    _move_file ~/dotfiles/update.sh ~/dotfiles/.config/ml4w/update.sh
    _move_file ~/dotfiles/uninstall.sh ~/dotfiles/.config/ml4w/uninstall.sh

    # dotfiles
    _move_folder ~/dotfiles/ags ~/dotfiles/.config/ags
    _move_folder ~/dotfiles/alacritty ~/dotfiles/.config/alacritty
    _move_folder ~/dotfiles/dunst ~/dotfiles/.config/dunst
    _move_folder ~/dotfiles/fastfetch ~/dotfiles/.config/fastfetch
    _move_folder ~/dotfiles/hypr ~/dotfiles/.config/hypr
    _move_folder ~/dotfiles/nvim ~/dotfiles/.config/nvim
    _move_folder ~/dotfiles/picom ~/dotfiles/.config/picom
    _move_folder ~/dotfiles/qt6ct ~/dotfiles/.config/qt6ct
    _move_folder ~/dotfiles/qtile ~/dotfiles/.config/qtile
    _move_folder ~/dotfiles/rofi ~/dotfiles/.config/rofi
    _move_folder ~/dotfiles/vim ~/dotfiles/.config/vim
    _move_folder ~/dotfiles/wal ~/dotfiles/.config/wal
    _move_folder ~/dotfiles/waybar ~/dotfiles/.config/waybar
    _move_folder ~/dotfiles/waypaper ~/dotfiles/.config/waypaper
    _move_folder ~/dotfiles/wlogout ~/dotfiles/.config/wlogout
    _move_folder ~/dotfiles/gtk/gtk3.0 ~/dotfiles/.config/gtk3.0
    _move_folder ~/dotfiles/gtk/gtk4.0 ~/dotfiles/.config/gtk4.0
    _move_folder ~/dotfiles/gtk/xsettings ~/dotfiles/.config/xsettings
    _move_file ~/dotfiles/gtk/.gtkrc-2.0 ~/dotfiles/.gtkrc-2.0
    _move_file ~/dotfiles/gtk/.Xresources ~/dotfiles/.Xresources
    _move_file ~/dotfiles/starship/startship.toml ~/dotfiles/startship.toml
    _del_folder ~/dotfiles/gtk
    _del_folder ~/dotfiles/eww
    _del_folder ~/dotfiles/starship
    _del_file ~/.Xresources
    _del_file ~/.gtkrc-2.0    
fi