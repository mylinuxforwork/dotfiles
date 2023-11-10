# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
cat <<"EOF"
 ___           _        _ _       _       _    __ _ _           
|_ _|_ __  ___| |_ __ _| | |   __| | ___ | |_ / _(_) | ___  ___ 
 | || '_ \/ __| __/ _` | | |  / _` |/ _ \| __| |_| | |/ _ \/ __|
 | || | | \__ \ || (_| | | | | (_| | (_) | |_|  _| | |  __/\__ \
|___|_| |_|___/\__\__,_|_|_|  \__,_|\___/ \__|_| |_|_|\___||___/
                                                                

EOF
echo "The script will now remove existing directories and files from ~/.config/"
echo "and copy your prepared configuration from ~/dotfiles-versions/$version to ~/dotfiles"
echo "Symbolic links will then be created from ~/dotfiles into your ~/.config/ directory."
echo "PLEASE BACKUP YOUR EXISTING CONFIGURATIONS IF NEEDED in .config"
echo ""

while true; do
    read -p "Do you want to install the dotfiles now? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ ! $mode == "dev" ]; then
                echo "Copy started"
                if [ ! -d ~/dotfiles ]; then
                    mkdir ~/dotfiles
                fi   
                cp -rf ~/dotfiles-versions/$version/. ~/dotfiles/
            else
                echo "Skipped: DEV MODE!"
            fi
        break;;
        [Nn]* ) 
            exit
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""

