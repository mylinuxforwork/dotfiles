# ------------------------------------------------------
# Monitor
# ------------------------------------------------------

if [[ $profile == *"Hyprland"* ]]; then
echo -e "${GREEN}"
figlet "Monitor"
echo -e "${NONE}"
    if [ "$monitorrestored" == "1" ]; then
        echo "Monitor settings could already be restored".
        echo ""
    else
        echo "Hyprland will use the following monitor setup from ~/dotfiles/hypr/conf/monitors/default.conf"
        echo "monitor=,preferred,auto,1"
        echo ""
        echo "You can create your own monitor configuration by adding a new variation file ~/dotfiles/hypr/conf/monitors/mymonitor.conf"
        echo "Add there your monitor configuration."
        echo ""
        echo "After starting Hyprland, you can select your custom monitor variation with SUPER+CMD+S (or by clicking on the settings icon in WayBar)."
        echo "Select Monitors and then your custom monitor variation: ~/dotfiles/hypr/conf/monitors/mymonitor.conf"
        echo ""
        echo "Or overwrite the path on ~/dotfiles/hypr/conf/monitor.conf and replace it with your custom variation."
        echo ""
        echo "More information on how to setup your monitor in the Hyprland Wiki: https://wiki.hyprland.org/Configuring/Monitors/"
        echo ""
    fi
fi