# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ ! -d ~/dotfiles ]; then
echo -e "${GREEN}"
cat <<"EOF"
 ___           _        _ _       _       _    __ _ _           
|_ _|_ __  ___| |_ __ _| | |   __| | ___ | |_ / _(_) | ___  ___ 
 | || '_ \/ __| __/ _` | | |  / _` |/ _ \| __| |_| | |/ _ \/ __|
 | || | | \__ \ || (_| | | | | (_| | (_) | |_|  _| | |  __/\__ \
|___|_| |_|___/\__\__,_|_|_|  \__,_|\___/ \__|_| |_|_|\___||___/
                                                                
EOF
echo -e "${NONE}"
else
echo -e "${GREEN}"
cat <<"EOF"
 _   _           _       _             _       _    __ _ _           
| | | |_ __   __| | __ _| |_ ___    __| | ___ | |_ / _(_) | ___  ___ 
| | | | '_ \ / _` |/ _` | __/ _ \  / _` |/ _ \| __| |_| | |/ _ \/ __|
| |_| | |_) | (_| | (_| | ||  __/ | (_| | (_) | |_|  _| | |  __/\__ \
 \___/| .__/ \__,_|\__,_|\__\___|  \__,_|\___/ \__|_| |_|_|\___||___/
      |_|                                                            

EOF
echo -e "${NONE}"
fi
if [ ! -d ~/dotfiles ]; then
echo "The script will now remove existing directories and files from ~/.config/"
echo "and copy your prepared configuration from ~/dotfiles-versions/$version to ~/dotfiles"
echo ""
echo "Symbolic links will then be created from ~/dotfiles into your ~/.config/ directory."
echo ""
fi
if [[ ! $(tty) == *"pts"* ]] && [ -d ~/dotfiles ]; then
    echo "You're running the script in tty. You can delete the existing ~/dotfiles folder now for a clean installation."
    echo "If not, the script will overwrite existing files but will not remove additional files or folders of your custom configuration."
    echo ""
else
    if [ -d ~/dotfiles ]; then
        echo "The script will overwrite existing files but will not remove additional files or folders of your custom configuration."
    fi
fi
if [ ! -d ~/dotfiles ]; then
    echo "PLEASE BACKUP YOUR EXISTING CONFIGURATIONS in .config IF NEEDED!"
    echo ""
fi

if gum confirm "Do you want to install the prepared dotfiles now?" ;then
    if [ ! $mode == "dev" ]; then
        echo "Copy started"
        if [ ! -d ~/dotfiles ]; then
            mkdir ~/dotfiles
            echo "~/dotfiles folder created."
        fi   
        rsync -avhp -I ~/dotfiles-versions/$version/ ~/dotfiles/
        if [[ $(_isFolderEmpty ~/dotfiles/) == 0 ]] ;then
            echo "AN ERROR HAS OCCURED. Copy prepared dofiles from ~/dotfiles-versions/$version/ to ~/dotfiles/ failed" 
            echo "Please check that rsync is installad on your system."
            echo "Execution of rsync -a -I ~/dotfiles-versions/$version/ ~/dotfiles/ is required."
            exit
        fi
        echo "All files from ~/dotfiles-versions/$version/ to ~/dotfiles/ copied."
    else
        echo "Skipped: DEV MODE!"
    fi
elif [ $? -eq 130 ]; then
        exit 130
else
    exit
fi
echo ""
