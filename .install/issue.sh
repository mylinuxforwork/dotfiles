# ------------------------------------------------------
# Install tty login and issue
# ------------------------------------------------------

if [ $disman == 1 ]; then
echo -e "${GREEN}"
figlet "TTY issue"
echo -e "${NONE}"
    if gum confirm "Do you want to install the custom tty login issue?" ;then
        sudo cp login/issue /etc/issue
        echo "Custom tty login issue installed successfully."
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo "Setup tty login skipped."
    fi
    echo ""
fi