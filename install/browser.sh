# ------------------------------------------------------
# Install tty login and issue
# ------------------------------------------------------
if [ -d ~/dotfiles ] ;then
    current_browser=$(cat ~/dotfiles/.settings/browser.sh)
    if [ ! "$current_browser" == "firefox" ] ;then
        echo -e "${GREEN}"
        figlet "Browser"
        echo -e "${NONE}"
        echo ":: The current browser is $current_browser"
        if gum confirm "Do your want to install Firefox instead?" ;then
            echo ":: Installing Firefox..."
            _installPackagesPacman "firefox"
            echo ":: Setting Firefox as Default browser"
            echo "firefox" > ~/dotfiles/.settings/browser.sh
            echo "firefox https://chat.openai.com" > ~/dotfiles/.settings/ai.sh
            xdg-settings set default-web-browser firefox.desktop
            echo
            gum spin --spinner dot --title "Recommended to change the browser icon to Firefox in ~/dotfiles/.settings/waybar-quicklinks.json" -- sleep 5
        elif [ $? -eq 130 ]; then
            echo ":: Installation canceled."
            exit 130
        else
            echo ":: Installation of Firefox skipped"
        fi
    fi
else
    echo ":: Firefox will be installed as default browser."
    _installPackagesPacman "firefox"
    echo ":: Setting Firefox as Default browser"
    xdg-settings set default-web-browser firefox.desktop
fi