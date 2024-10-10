# ------------------------------------------------------
# Modify existing files before restore starts
# ------------------------------------------------------

if [ -d ~/$dot_folder/.settings ] ;then
    echo ":: Legacy folder structure detected."
    if [ -d ~/$dot_folder ] ;then
        echo ":: Modify existing files"

        # Create new folder structure
        if [ ! -d ~/$dot_folder/.config ] ;then
            mkdir ~/$dot_folder/.config
        fi
        mv -f ~/$dot_folder/* ~/$dot_folder/.config/
        if [ ! -d ~/$dot_folder/.config/ml4w ] ;then
            mkdir ~/$dot_folder/.config/ml4w
        fi

        # ml4w folder
        _move_folder ~/$dot_folder/.settings ~/$dot_folder/.config/ml4w/settings
        _move_folder ~/$dot_folder/.config/scripts ~/$dot_folder/.config/ml4w/scripts
        _move_folder ~/$dot_folder/.version  ~/$dot_folder/.config/ml4w/version
        _move_folder ~/$dot_folder/.config/apps ~/$dot_folder/.config/ml4w/apps
        _move_folder ~/$dot_folder/.config/login ~/$dot_folder/.config/ml4w/login
        _move_folder ~/$dot_folder/.config/sddm ~/$dot_folder/.config/ml4w/sddm
        _move_file ~/$dot_folder/.config/update.sh ~/$dot_folder/.config/ml4w/update.sh
        _move_file ~/$dot_folder/.config/uninstall.sh ~/$dot_folder/.config/ml4w/uninstall.sh

        # dotfiles
        _move_folder ~/$dot_folder/.config/gtk/gtk3.0 ~/$dot_folder/.config/gtk3.0
        _move_folder ~/$dot_folder/.config/gtk/gtk4.0 ~/$dot_folder/.config/gtk4.0
        _move_folder ~/$dot_folder/.config/gtk/xsettings ~/$dot_folder/.config/xsettings
        _move_file ~/$dot_folder/.config/gtk/.gtkrc-2.0 ~/$dot_folder/.gtkrc-2.0
        _move_file ~/$dot_folder/.config/gtk/.Xresources ~/$dot_folder/.Xresources
        _del_folder ~/$dot_folder/gtk
        _del_folder ~/$dot_folder/eww

        # Replace Quicklink
        sed -i -e 's/dotfiles\/.settings/.config\/ml4w\/settings/g' ~/$dot_folder/.config/ml4w/settings/waybar-quicklinks.json
    fi
fi

# Move legacy .bashrc_custom to ~/.config/bashrc/bashrc_custom
if [ -f ~/.bashrc_custom ] ;then
    mv ~/.bashrc_custom ~/$dot_folder/.config/bashrc/bashrc_custom
fi