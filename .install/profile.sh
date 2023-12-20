# ------------------------------------------------------
# Select installation profile
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
 ____            _    _                ____             __ _ _      
|  _ \  ___  ___| | _| |_ ___  _ __   |  _ \ _ __ ___  / _(_) | ___ 
| | | |/ _ \/ __| |/ / __/ _ \| '_ \  | |_) | '__/ _ \| |_| | |/ _ \
| |_| |  __/\__ \   <| || (_) | |_) | |  __/| | | (_) |  _| | |  __/
|____/ \___||___/_|\_\\__\___/| .__/  |_|   |_|  \___/|_| |_|_|\___|
                              |_|                                   

EOF
echo -e "${NONE}"

echo "SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL"
profile=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "Hyprland" "Qtile")
if [ -z $profile ] ;then
    echo "No profile selected. Installation canceled."
    exit
fi
