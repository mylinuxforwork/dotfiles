# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
_writeLogHeader "Copy"

_copy_confirm() {
    if gum confirm "Do you want to install the prepared ML4W Dotfiles now?" ;then
        _writeLog 1 "Copy started"
        if [ ! -d ~/$dot_folder ]; then
            mkdir -p ~/$dot_folder
            _writeLog 1 "~/$dot_folder folder created."
        fi   
        rsync -avhp -I $ml4w_directory/$version/ ~/$dot_folder/ &>> $(_getLogFile)
        if [[ $(_isFolderEmpty ~/$dot_folder/) == 0 ]]; then
            _writeLogTerminal 2 "AN ERROR HAS OCCURED. Copy prepared dofiles from $ml4w_directory/$version/ to ~/$dot_folder/ failed" 
            _writeLogTerminal 2 "Please check that rsync is installad on your system."
            _writeLogTerminal 2 "Execution of rsync -a -I $ml4w_directory/$version/ ~/$dot_folder/ is required."
            exit
        fi
        _writeLogTerminal 1 "All files from $ml4w_directory/$version/ to ~/$dot_folder/ copied."
    elif [ $? -eq 130 ]; then
        _writeCancel
        exit 130
    else
        _writeCancel
        exit
    fi
}

_copy_automation() {
    if [ ! -d ~/$dot_folder ]; then
        mkdir -p ~/$dot_folder
        _writeLog 1 "AUTOMATION: ~/$dot_folder folder created."
    fi   
    rsync -avhp -I $ml4w_directory/$version/ ~/$dot_folder/ &>> $(_getLogFile)
    if [[ $(_isFolderEmpty ~/$dot_folder/) == 0 ]]; then
        _writeLogTerminal 2 "AN ERROR HAS OCCURED. Copy prepared dofiles from $ml4w_directory/$version/ to ~/$dot_folder/ failed" 
        _writeLogTerminal 2 "Please check that rsync is installad on your system."
        _writeLogTerminal 2 "Execution of rsync -a -I $ml4w_directory/$version/ ~/$dot_folder/ is required."
        exit
    fi
    _writeLog 1 "AUTOMATION: Prepared dotfiles copied to ~/$dot_folder"
}

_writeHeader "Copy"

if [ ! -d ~/$dot_folder ]; then
_writeLogTerminal 0 "The script will now remove existing directories and files from ~/.config/"
_writeLogTerminal 0 "and copy your prepared configuration from $ml4w_directory/$version to ~/$dot_folder"
echo
_writeLogTerminal 0 "Symbolic links will then be created from ~/$dot_folder into your ~/.config/ directory."
echo
fi
if [[ ! $(tty) == *"pts"* ]] && [ -d ~/$dot_folder ]; then
    _writeMessage "You're running the script in tty. You can delete the existing ~/$dot_folder folder now for a clean installation."
    _writeMessage "If not, the script will overwrite existing files but will not remove additional files or folders of your custom configuration."
    echo
else
    if [ -d ~/$dot_folder ]; then
        _writeMessage "The script will overwrite existing files but will not remove additional files or folders from your custom configuration."
        echo
    fi
fi
if [ ! -d ~/$dot_folder ]; then
    _writeMessage "PLEASE BACKUP YOUR EXISTING CONFIGURATIONS in .config IF NEEDED!"
    echo
fi

if [ -z $automation_copy ]; then
    _copy_confirm
else
    if [[ "$automation_copy" = true ]]; then
        _copy_automation
    else
        _copy_confirm
    fi
fi
