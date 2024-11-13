# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------
_writeLogHeader "Apps"

# Create local applications folder if not exits
if [ ! -d $HOME/.local/share/applications/ ] ;then
    mkdir $HOME/.local/share/applications
    _writeLog 1 "$HOME/.local/share/applications created"
fi

# Installing the ML4W Apps
app_name="com.ml4w.welcome"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
_writeLog 1 "ML4W Welcome App installed successfully"

app_name="com.ml4w.dotfilessettings"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
_writeLog 1 "ML4W Settings App installed successfully"

app_name="com.ml4w.hyprland.settings"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
_writeLog 1 "ML4W Hyprland Settings App installed successfully"

echo 

_writeLogHeader "Hyprland Settings App"

# Execute hyprctl from the Settings app
if [ -f ~/.config/ml4w-hyprland-settings/hyprctl.sh ] ;then
    _writeLog 0 "Starting restore from ML4W Hyprland Settings App"
    ~/.config/ml4w-hyprland-settings/hyprctl.sh
fi
echo