# ------------------------------------------------------
# Select installation profile
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Profile"
echo -e "${NONE}"

echo "SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL"
profile=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "Hyprland" "Qtile")

if [ -z "${profile}" ] ;then
    echo "No profile selected. Installation canceled."
    exit
else
    echo "Profile/s selected:" $profile
fi
