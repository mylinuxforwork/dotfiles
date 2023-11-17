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
echo "Please select the Desktop Profile for your installation:"
echo "1  - Hyprland"
echo "2  - Qtile"
echo "3  - All"
echo "Nn - Cancel"
echo ""
while true; do
    read -p "PLEASE SELECT: " yn
    case $yn in
        [1]* )
            profile="Hyprland"
        break;;
        [2]* )
            profile="Qtile"
        break;;
        [3]* )
            profile="All"
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""
echo "Installing profile $profile ..."
sleep 2
echo ""