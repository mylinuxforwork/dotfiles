# ------------------------------------------------------
# Update System
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "System Update"
echo -e "${NONE}"
echo "It's recommended to update your system before you proceed."
echo
if [ -z $automation_checkforupdates ] ;then
    if gum confirm "Do you want to update your system now?" ;then
        echo ":: Update started"
        $aur_helper
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: System update skipped"
    fi
else
    if [[ "$automation_checkforupdates" = true ]] ;then
        echo ":: AUTOMATION: Installing system updates"
        echo
        $aur_helper --noconfirm
    elif [[ "$automation_checkforupdates" = false ]] ;then
        echo ":: AUTOMATION: Installation of system updates skipped"
        echo
    else
        echo ":: AUTOMATION ERROR: Automation of installing system updates failed."
        echo
        exit
    fi
fi
echo
