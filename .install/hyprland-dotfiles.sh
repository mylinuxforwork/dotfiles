# ------------------------------------------------------
# Install dotfiles
# ------------------------------------------------------

if [ ! $mode == "dev" ]; then
    _installSymLink alacritty ~/.config/alacritty ~/dotfiles/alacritty/ ~/.config
    _installSymLink vim ~/.config/vim ~/dotfiles/vim/ ~/.config
    _installSymLink nvim ~/.config/nvim ~/dotfiles/nvim/ ~/.config
    _installSymLink starship ~/.config/starship.toml ~/dotfiles/starship/starship.toml ~/.config/starship.toml
    _installSymLink rofi ~/.config/rofi ~/dotfiles/rofi/ ~/.config
    _installSymLink dunst ~/.config/dunst ~/dotfiles/dunst/ ~/.config
    _installSymLink hypr ~/.config/hypr ~/dotfiles/hypr/ ~/.config
    _installSymLink waybar ~/.config/waybar ~/dotfiles/waybar/ ~/.config
    _installSymLink swaylock ~/.config/swaylock ~/dotfiles/swaylock/ ~/.config
    _installSymLink wlogout ~/.config/wlogout ~/dotfiles/wlogout/ ~/.config
    _installSymLink swappy ~/.config/swappy ~/dotfiles/swappy/ ~/.config
    _installSymLink .gtkrc-2.0 ~/.gtkrc-2.0 ~/dotfiles/gtk/.gtkrc-2.0 ~/.gtkrc-2.0
    _installSymLink .Xresources ~/.Xresources ~/dotfiles/gtk/.Xresources ~/.Xresources
    _installSymLink gtk-3.0 ~/.config/gtk-3.0 ~/dotfiles/gtk/gtk-3.0/ ~/.config/
    _installSymLink gtk-4.0 ~/.config/gtk-4.0 ~/dotfiles/gtk/gtk-4.0/ ~/.config/            
else
    echo "Skipped: DEV MODE!"
fi
echo "Symbolic links created."
echo ""