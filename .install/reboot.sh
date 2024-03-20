# ------------------------------------------------------
# Reboot
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Done"
echo -e "${NONE}"
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
