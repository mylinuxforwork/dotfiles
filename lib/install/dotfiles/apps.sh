# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------
_writeLogHeader "Apps"

# Create local applications folder if not exits
if [ ! -d $HOME/.local/share/applications/ ] ;then
    mkdir $HOME/.local/share/applications
    _writeLog 1 "$HOME/.local/share/applications created"
fi

# Remove legacy ML4W Apps
app_name="com.ml4w.welcome"
if [ -f /usr/bin/$app_name ] ;then
    sudo rm $apps_directory/$app_name.desktop /usr/share/applications
    sudo rm $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
    sudo rm $apps_directory/$app_name /usr/bin/$app_name
    _writeLog 1 "Legacy ML4W Welcome App removed successfully"
fi

app_name="com.ml4w.dotfilessettings"
if [ -f /usr/bin/$app_name ] ;then
    sudo rm $apps_directory/$app_name.desktop /usr/share/applications
    sudo rm $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
    sudo rm $apps_directory/$app_name /usr/bin/$app_name
    _writeLog 1 "Legacy ML4W Settings App removed successfully"
fi

app_name="com.ml4w.hyprland.settings"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
_writeLog 1 "ML4W Hyprland Settings App installed successfully"

# Installation of FlatPaks
$install_directory/dotfiles/flatpak.sh $apps_directory

_writeLogHeader "Hyprland Settings App"

# Execute hyprctl from the Settings app
if [ -f ~/.config/ml4w-hyprland-settings/hyprctl.sh ] ;then
    _writeLog 0 "Starting restore from ML4W Hyprland Settings App"
    ~/.config/ml4w-hyprland-settings/hyprctl.sh
fi