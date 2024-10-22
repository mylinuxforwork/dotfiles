# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------

_copy_confirm() {
    if gum confirm "Do you want to install the prepared ML4W Dotfiles now?" ;then
        echo "Copy started"
        if [ ! -d ~/$dot_folder ]; then
            mkdir -p ~/$dot_folder
            echo "~/$dot_folder folder created."
        fi   
        rsync -avhp -I $ml4w_directory/$version/ ~/$dot_folder/
        if [[ $(_isFolderEmpty ~/$dot_folder/) == 0 ]] ;then
            echo "AN ERROR HAS OCCURED. Copy prepared dofiles from $ml4w_directory/$version/ to ~/$dot_folder/ failed" 
            echo "Please check that rsync is installad on your system."
            echo "Execution of rsync -a -I $ml4w_directory/$version/ ~/$dot_folder/ is required."
            exit
        fi
        echo "All files from $ml4w_directory/$version/ to ~/$dot_folder/ copied."
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled"
        exit 130
    else
        echo ":: Installation canceled"
        exit
    fi
}

_copy_automation() {
    if [ ! -d ~/$dot_folder ]; then
        mkdir -p ~/$dot_folder
        echo ":: AUTOMATION: ~/$dot_folder folder created."
    fi   
    rsync -avhp -I $ml4w_directory/$version/ ~/$dot_folder/
    if [[ $(_isFolderEmpty ~/$dot_folder/) == 0 ]] ;then
        echo "AN ERROR HAS OCCURED. Copy prepared dofiles from $ml4w_directory/$version/ to ~/$dot_folder/ failed" 
        echo "Please check that rsync is installad on your system."
        echo "Execution of rsync -a -I $ml4w_directory/$version/ ~/$dot_folder/ is required."
        exit
    fi
    echo ":: AUTOMATION: Prepared dotfiles copied to ~/$dot_folder"
}

echo -e "${GREEN}"
figlet -f smslant "Copy"
echo -e "${NONE}"
if [ ! -d ~/$dot_folder ]; then
echo "The script will now remove existing directories and files from ~/.config/"
echo "and copy your prepared configuration from $ml4w_directory/$version to ~/$dot_folder"
echo
echo "Symbolic links will then be created from ~/$dot_folder into your ~/.config/ directory."
echo
fi
if [[ ! $(tty) == *"pts"* ]] && [ -d ~/$dot_folder ]; then
    echo "You're running the script in tty. You can delete the existing ~/$dot_folder folder now for a clean installation."
    echo "If not, the script will overwrite existing files but will not remove additional files or folders of your custom configuration."
    echo
else
    if [ -d ~/$dot_folder ]; then
        echo "The script will overwrite existing files but will not remove additional files or folders from your custom configuration."
        echo
    fi
fi
if [ ! -d ~/$dot_folder ]; then
    echo "PLEASE BACKUP YOUR EXISTING CONFIGURATIONS in .config IF NEEDED!"
    echo
fi

if [ -z $automation_copy ] ;then
    _copy_confirm
else
    if [[ "$automation_copy" = true ]] ;then
        _copy_automation
    else
        _copy_confirm
    fi
fi
echo
