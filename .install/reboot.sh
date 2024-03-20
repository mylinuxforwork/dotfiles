# ------------------------------------------------------
# Reboot
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Reboot"
echo -e "${NONE}"
echo "A reboot of your system is recommended."
if gum confirm "Do you want to reboot your system now?" ;then
    echo ":: Rebooting now ..."
    sleep 3
    systemctl reboot
elif [ $? -eq 130 ]; then
    exit 130
else
    echo ":: Reboot skipped"
fi
echo ""
