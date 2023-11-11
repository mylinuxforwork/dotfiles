# ------------------------------------------------------
# Setup
# ------------------------------------------------------

cat <<"EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|    

EOF
echo "If you could restore your keyboard layout in the step before you can select Nn and skip."
while true; do
    read -p "Do you want to start the setup (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            read -p "Enter your preferred keyboard layout (us,de,...) (default:us): " keyboard
            if [ -z "$keyboard" ]; then
                keyboard="us"
            fi
            SEARCH="kb_layout = us"
            REPLACE="kb_layout = $keyboard"
            sed -i "s/$SEARCH/$REPLACE/g" ~/dotfiles-versions/$version/hypr/conf/keyboard.conf

            SEARCH="keyboard_layout = \"us\""
            REPLACE="keyboard_layout = \"$keyboard\""
            sed -i "s/$SEARCH/$REPLACE/g" ~/dotfiles-versions/$version/qtile/conf/keyboard.py
        break;;
        [Nn]* ) 
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
