# ------------------------------------------------------
# Update System
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "System Update"
echo -e "${NONE}"
echo "It's recommended to update your system before you proceed."
echo 
if gum confirm "Do you want to update your system with yay now?" ;then
    echo ":: Update started"
    yay
elif [ $? -eq 130 ]; then
    echo ":: Installation canceled."
    exit 130
else
    echo ":: System update skipped"
fi
echo
