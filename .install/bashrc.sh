# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

echo "-> Install .bashrc"
echo "PLEASE BACKUP YOUR .bashrc file in case you want to keep your local configuration and aliases."
while true; do
    read -p "Do you want to install the .bashrc file? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            _installSymLink .bashrc ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc
        break;;
        [Nn]* ) 
            echo "Installation skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""
