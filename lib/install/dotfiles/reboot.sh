# ------------------------------------------------------
# Reboot
# ------------------------------------------------------
_writeLogHeader "Reboot"
_writeHeader "Done"
echo "A reboot of your system is recommended."
echo
if gum confirm "Do you want to reboot your system now?" ;then
    gum spin --spinner dot --title "Rebooting now..." -- sleep 3
    systemctl reboot
elif [ $? -eq 130 ]; then
    exit 130
else
    echo ":: Reboot skipped"
fi
echo ""
