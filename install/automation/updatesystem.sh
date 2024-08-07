# ------------------------------------------------------
# System Update
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "System Update"
echo -e "${NONE}"
if [[ "$automation_checkforupdates" = true ]] ;then
    echo ":: AUTOMATION: Installing system updates"
    echo
    yay --noconfirm
elif [[ "$automation_checkforupdates" = false ]] ;then
    echo ":: AUTOMATION: Installation of system updates skipped"
    echo
else
    echo ":: AUTOMATION ERROR: Automation of installing system updates failed."
    echo
    exit
fi
