# ------------------------------------------------------
# Modify existing files before restore starts
# ------------------------------------------------------

if [ -d ~/$dot_folder ] ;then
    echo ":: Modify existing files"
    if [ ! -d ~/$dot_folder/.config ] ;then
        mkdir ~/$dot_folder/.config
    fi
    if [ ! -d ~/$dot_folder/.config/ml4w ] ;then
        mkdir ~/$dot_folder/.config/ml4w
    fi

    # ml4w folder
    _move_folder ~/$dot_folder/.settings ~/$dot_folder/.config/ml4w/settings
    _move_folder ~/$dot_folder/scripts ~/$dot_folder/.config/ml4w/scripts
    _move_folder ~/$dot_folder/.version  ~/$dot_folder/.config/ml4w/version
    _move_folder ~/$dot_folder/apps ~/$dot_folder/.config/ml4w/apps
    _move_folder ~/$dot_folder/login ~/$dot_folder/.config/ml4w/login
    _move_folder ~/$dot_folder/sddm ~/$dot_folder/.config/ml4w/sddm
    _move_file ~/$dot_folder/update.sh ~/$dot_folder/.config/ml4w/update.sh
    _move_file ~/$dot_folder/uninstall.sh ~/$dot_folder/.config/ml4w/uninstall.sh

    # dotfiles
    _move_folder ~/$dot_folder/ags ~/$dot_folder/.config/ags
    _move_folder ~/$dot_folder/alacritty ~/$dot_folder/.config/alacritty
    _move_folder ~/$dot_folder/dunst ~/$dot_folder/.config/dunst
    _move_folder ~/$dot_folder/fastfetch ~/$dot_folder/.config/fastfetch
    _move_folder ~/$dot_folder/hypr ~/$dot_folder/.config/hypr
    _move_folder ~/$dot_folder/nvim ~/$dot_folder/.config/nvim
    _move_folder ~/$dot_folder/picom ~/$dot_folder/.config/picom
    _move_folder ~/$dot_folder/qt6ct ~/$dot_folder/.config/qt6ct
    _move_folder ~/$dot_folder/qtile ~/$dot_folder/.config/qtile
    _move_folder ~/$dot_folder/rofi ~/$dot_folder/.config/rofi
    _move_folder ~/$dot_folder/vim ~/$dot_folder/.config/vim
    _move_folder ~/$dot_folder/wal ~/$dot_folder/.config/wal
    _move_folder ~/$dot_folder/waybar ~/$dot_folder/.config/waybar
    _move_folder ~/$dot_folder/waypaper ~/$dot_folder/.config/waypaper
    _move_folder ~/$dot_folder/wlogout ~/$dot_folder/.config/wlogout
    _move_folder ~/$dot_folder/gtk/gtk3.0 ~/$dot_folder/.config/gtk3.0
    _move_folder ~/$dot_folder/gtk/gtk4.0 ~/$dot_folder/.config/gtk4.0
    _move_folder ~/$dot_folder/gtk/xsettings ~/$dot_folder/.config/xsettings
    _move_file ~/$dot_folder/gtk/.gtkrc-2.0 ~/$dot_folder/.gtkrc-2.0
    _move_file ~/$dot_folder/gtk/.Xresources ~/$dot_folder/.Xresources
    _move_file ~/$dot_folder/starship/starship.toml ~/$dot_folder/starship.toml
    _del_folder ~/$dot_folder/gtk
    _del_folder ~/$dot_folder/eww
    _del_folder ~/$dot_folder/starship
fi