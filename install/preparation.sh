# ------------------------------------------------------
# Prepare dotfiles
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Preparation"
echo -e "${NONE}"

# Check existing .config folder
if [ -d ~/.config ]; then
    echo ":: $HOME/.config folder already exists."
else
    mkdir ~/.config
    echo ":: $HOME/.config folder created."
fi
echo

# Create required folder structure
echo "Preparing temporary folders for the installation."
if [ ! -d ~/dotfiles-versions ] ;then
    mkdir ~/dotfiles-versions
    echo ":: ~/dotfiles-versions folder created."
fi
if [ ! -d ~/dotfiles-versions/$version ] ;then
    mkdir ~/dotfiles-versions/$version
    echo ":: ~/dotfiles-versions/$version folder created."
else
    echo ":: The folder ~/dotfiles-versions/$version already exists from previous installations."
    rm -rf ~/dotfiles-versions/$version
    mkdir ~/dotfiles-versions/$version
    echo ":: Clean build prepared for the installation."
fi
if [ ! -d ~/dotfiles-versions/library ] ;then
    mkdir ~/dotfiles-versions/library
    echo ":: library folder created"
fi

# Copy files to the destination
rsync -a -I --exclude-from=install/includes/excludes.txt dotfiles/. ~/dotfiles-versions/$version/

# Check copy success
if [[ $(_isFolderEmpty ~/dotfiles-versions/$version/) == 0 ]] ;then
    echo "AN ERROR HAS OCCURED. Preparation of ~/dotfiles-versions/$version/ failed" 
    echo "Please check that rsync is installad on your system."
    echo "Execution of rsync -a -I --exclude-from=install/includes/excludes.txt . ~/dotfiles-versions/$version/ is required."
    exit
fi
echo ":: ML4W Dotfiles $version successfully prepared in ~/dotfiles-versions/$version/"

# Copy hook.tpl if hook.sh not exists
if [ ! -f ~/dotfiles-versions/hook.sh ] ;then
    cp install/templates/hook.tpl ~/dotfiles-versions/
    echo ":: hook.tpl created"
else
    chmod +x ~/dotfiles-versions/hook.sh
    echo ":: hook.sh already exists"
fi

# Copy post.tpl if post.sh not exists
if [ ! -f ~/dotfiles-versions/post.sh ] ;then
    cp install/templates/post.tpl ~/dotfiles-versions/
    echo ":: post.tpl created"
else
    chmod +x ~/dotfiles-versions/post.sh
    echo ":: post.sh already exists"
fi

# Copy automation.tpl
cp install/templates/automation.tpl ~/dotfiles-versions/
echo ":: automation.tpl created"

# Copy activate.sh
cp install/templates/activate.sh ~/dotfiles-versions/
chmod +x ~/dotfiles-versions/activate.sh
echo ":: activate.sh updated"

# Prepare library folder
cp install/includes/scripts.sh ~/dotfiles-versions/library/
echo ":: scripts.sh for $version updated in ~/dotfiles-versions/library"
if [ ! -f ~/dotfiles-versions/library/version.sh ] ;then
    touch ~/dotfiles-versions/library/version.sh
fi
echo "$version" > ~/dotfiles-versions/library/version.sh
echo ":: version.sh updated with $version"

# Write dot folder into settings
echo "$dot_folder" > ~/dotfiles-versions/$version/.config/ml4w/settings/dotfiles-folder.sh