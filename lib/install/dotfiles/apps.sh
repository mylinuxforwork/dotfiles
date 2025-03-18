# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------
_writeHeader "Apps"
echo "Installing the ML4W Apps now."
_removeLegacyApp() {
    app_name=$1
    if [ -f /usr/share/applications/$app_name.desktop ]; then
        sudo rm /usr/share/applications/$app_name.desktop
    fi
    if [ -f /usr/share/icons/hicolor/128x128/apps/$app_name.png ]; then
        sudo rm /usr/share/icons/hicolor/128x128/apps/$app_name.png
    fi
    if [ -f /usr/bin/$app_name ]; then
        sudo rm /usr/bin/$app_name
        _writeLog 1 "Legacy $app_name App removed successfully"
    fi
}

# Create local applications folder if not exits
if [ ! -d $HOME/.local/share/applications/ ]; then
    mkdir $HOME/.local/share/applications
    _writeLog 1 "$HOME/.local/share/applications created"
fi

# Remove legacy ML4W Apps
_removeLegacyApp "com.ml4w.welcome"
_removeLegacyApp "com.ml4w.dotfilessettings"
_removeLegacyApp "com.ml4w.hyprland.settings"

# Installation of ML4W Flatpaks from GitHub remote
curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles-welcome/master/setup.sh | bash -s -- -y &>>$(_getLogFile)
curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles-settings/master/setup.sh | bash -s -- -y &>>$(_getLogFile)
curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles-sidebar/master/setup.sh | bash -s -- -y &>>$(_getLogFile)
curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles-calendar/master/setup.sh | bash -s -- -y &>>$(_getLogFile)
curl -s https://raw.githubusercontent.com/mylinuxforwork/hyprland-settings/master/setup.sh | bash -s -- -y &>>$(_getLogFile)

# Copy Icons
mkdir -p $HOME/.local/share/icons
cp $apps_directory/icons/com.ml4w.welcome.png $HOME/.local/share/icons/
cp $apps_directory/icons/com.ml4w.settings.png $HOME/.local/share/icons/
cp $apps_directory/icons/com.ml4w.calendar.png $HOME/.local/share/icons/
cp $apps_directory/icons/com.ml4w.sidebar.png $HOME/.local/share/icons/
cp $apps_directory/icons/com.ml4w.hyprlandsettings.png $HOME/.local/share/icons/

_writeLogHeader "Run Hyprland Settings App"

# Execute hyprctl from the Settings app
if [ -f ~/.config/com.ml4w.hyprlandsettings/hyprctl.sh ]; then
    _writeLog 0 "Starting restore from ML4W Hyprland Settings App"
    ~/.config/com.ml4w.hyprlandsettings/hyprctl.sh
fi
