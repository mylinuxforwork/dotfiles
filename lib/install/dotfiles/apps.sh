# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------

# Create local applications folder if not exits
if [ ! -d $HOME/.local/share/applications/ ] ;then
    mkdir $HOME/.local/share/applications
    echo ":: $HOME/.local/share/applications created"
fi

# Downloading the App
sed -i "s|HOME|${HOME}|g" $HOME/.config/ml4w/apps/ml4w-welcome.desktop
cp $HOME/.config/ml4w/apps/ml4w-welcome.desktop $HOME/.local/share/applications
cp $HOME/.config/ml4w/apps/com.ml4w.welcome.png $HOME/.local/share/icons/hicolor/128x128/apps
echo ":: ML4W Welcome App installed successfully"

sed -i "s|HOME|${HOME}|g" $HOME/.config/ml4w/apps/ml4w-dotfiles-settings.desktop
cp $HOME/.config/ml4w/apps/ml4w-dotfiles-settings.desktop $HOME/.local/share/applications
cp $HOME/.config/ml4w/apps/com.ml4w.dotfilessettings.png $HOME/.local/share/icons/hicolor/128x128/apps
echo ":: ML4W Settings App installed successfully"

sed -i "s|HOME|${HOME}|g" $HOME/.config/ml4w/apps/ml4w-hyprland-settings.desktop
cp $HOME/.config/ml4w/apps/ml4w-hyprland-settings.desktop $HOME/.local/share/applications
cp $HOME/.config/ml4w/apps/com.ml4w.hyprland.settings.png $HOME/.local/share/icons/hicolor/128x128/apps
echo ":: ML4W Hyprland Settings App installed successfully"

echo ":: ML4W Uninstaller App installed successfully"

echo 

# Execute hyprctl from the Settings app
if [ -f ~/.config/ml4w-hyprland-settings/hyprctl.sh ] ;then
    echo ":: Starting restore from ML4W Hyprland Settings App"
    ~/.config/ml4w-hyprland-settings/hyprctl.sh
fi
echo