# ------------------------------------------------------
# Install tty login and issue
# ------------------------------------------------------

if [ $disman == 1 ]; then
echo -e "${GREEN}"
cat <<"EOF"
 _____ _______   __  _             _       
|_   _|_   _\ \ / / | | ___   __ _(_)_ __  
  | |   | |  \ V /  | |/ _ \ / _` | | '_ \ 
  | |   | |   | |   | | (_) | (_| | | | | |
  |_|   |_|   |_|   |_|\___/ \__, |_|_| |_|
                             |___/         

EOF
echo -e "${NONE}"
    if gum confirm "Do you want to install the custom tty login issue?" ;then
        sudo cp login/issue /etc/issue
    else
        echo "Setup tty login skipped."
    fi
    echo ""
fi