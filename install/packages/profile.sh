# ------------------------------------------------------
# Select installation profile
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Profile"
echo -e "${NONE}"
if [ -z $automation_profile ] ;then
    echo "Please select your installation profile."
    echo
    profile=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "Hyprland" "Qtile")

    if [ -z "${profile}" ] ;then
        echo ":: No profile selected. Installation canceled."
        exit
    else
        echo ":: Profile/s selected:" $profile
    fi
else
    profile=$automation_profile
    if [ -z "${profile}" ] ;then
        echo ":: AUTOMATION ERROR: No profile selected. Installation canceled."
        exit
    else
        echo ":: AUTOMATION: Profile/s selected:" $profile
        echo 
    fi
fi
echo
