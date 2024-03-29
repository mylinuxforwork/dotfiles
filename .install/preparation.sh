# ------------------------------------------------------
# Prepare dotfiles
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Preparation"
echo -e "${NONE}"
if [ -d ~/.config ]; then
    echo ":: $HOME/.config folder already exists."
else
    mkdir ~/.config
    echo ":: $HOME/.config folder created."
fi
echo
echo "Preparing temporary folders for the installation."
if [ ! -d ~/dotfiles-versions ]; then
    mkdir ~/dotfiles-versions
    echo ":: ~/dotfiles-versions folder created."
fi
if [ ! -d ~/dotfiles-versions/$version ]; then
    mkdir ~/dotfiles-versions/$version
    echo ":: ~/dotfiles-versions/$version folder created."
else
    echo ":: The folder ~/dotfiles-versions/$version already exists from previous installations."
    rm -rf ~/dotfiles-versions/$version
    mkdir ~/dotfiles-versions/$version
    echo ":: Clean build prepared for the installation."
fi
rsync -a -I --exclude-from=.install/includes/excludes.txt . ~/dotfiles-versions/$version/
if [[ $(_isFolderEmpty ~/dotfiles-versions/$version/) == 0 ]] ;then
    echo "AN ERROR HAS OCCURED. Preparation of ~/dotfiles-versions/$version/ failed" 
    echo "Please check that rsync is installad on your system."
    echo "Execution of rsync -a -I --exclude-from=.install/includes/excludes.txt . ~/dotfiles-versions/$version/ is required."
    exit
fi
echo ":: ML4W Dotfiles $version successfully prepared in ~/dotfiles-versions/$version/"
echo
