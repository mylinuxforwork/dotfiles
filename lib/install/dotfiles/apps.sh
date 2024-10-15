# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------

echo -e "${GREEN}"
figlet -f smslant "Apps"
echo -e "${NONE}"

# Create local applications folder if not exits
if [ ! -d $HOME/.local/share/applications/ ] ;then
    mkdir $HOME/.local/share/applications
    echo ":: $HOME/.local/share/applications created"
fi

# Installing the ML4W Apps
app_name="com.ml4w.welcome"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
echo ":: ML4W Welcome App installed successfully"

app_name="com.ml4w.dotfilessettings"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
echo ":: ML4W Settings App installed successfully"

app_name="com.ml4w.hyprland.settings"
sudo cp $apps_directory/$app_name.desktop /usr/share/applications
sudo cp $apps_directory/$app_name.png /usr/share/icons/hicolor/128x128/apps
sudo cp $apps_directory/$app_name /usr/bin/$app_name
echo ":: ML4W Hyprland Settings App installed successfully"

echo 

# Execute hyprctl from the Settings app
if [ -f ~/.config/ml4w-hyprland-settings/hyprctl.sh ] ;then
    echo ":: Starting restore from ML4W Hyprland Settings App"
    ~/.config/ml4w-hyprland-settings/hyprctl.sh
fi
echo