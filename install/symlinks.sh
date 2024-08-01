# ------------------------------------------------------
# Install dotfiles
# ------------------------------------------------------

# Delete existing symlinks
_del_symlink ~/.Xresources
_del_symlink ~/.gtkrc-2.0
_del_symlink ~/.bashrc
_del_symlink ~/.config/ags
_del_symlink ~/.config/alacritty
_del_symlink ~/.config/starship.toml
_del_symlink ~/.config/dunst
_del_symlink ~/.config/eww
_del_symlink ~/.config/fastfetch
_del_symlink ~/.config/hypr
_del_symlink ~/.config/nvim
_del_symlink ~/.config/picom
_del_symlink ~/.config/qt6ct
_del_symlink ~/.config/qtile
_del_symlink ~/.config/rofi
_del_symlink ~/.config/vim
_del_symlink ~/.config/wal
_del_symlink ~/.config/waypaper
_del_symlink ~/.config/waybar
_del_symlink ~/.config/wlogout

stow .

echo ":: Symbolic links created."
echo
