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
if [ ! -d ~/$ml4w_directory ] ;then
    mkdir ~/$ml4w_directory
    echo ":: ~/$ml4w_directory folder created."
fi
if [ ! -d ~/$ml4w_directory/$version ] ;then
    mkdir ~/$ml4w_directory/$version
    echo ":: ~/$ml4w_directory/$version folder created."
else
    echo ":: The folder ~/$ml4w_directory/$version already exists from previous installations."
    rm -rf ~/$ml4w_directory/$version
    mkdir ~/$ml4w_directory/$version
    echo ":: Clean build prepared for the installation."
fi
if [ ! -d ~/$ml4w_directory/library ] ;then
    mkdir ~/$ml4w_directory/library
    echo ":: library folder created"
fi

# Copy files to the destination
rsync -a -I --exclude-from=$lib_directory/includes/excludes.txt dotfiles/. ~/$ml4w_directory/$version/

# Check copy success
if [[ $(_isFolderEmpty ~/$ml4w_directory/$version/) == 0 ]] ;then
    echo "AN ERROR HAS OCCURED. Preparation of ~/$ml4w_directory/$version/ failed" 
    echo "Please check that rsync is installad on your system."
    echo "Execution of rsync -a -I --exclude-from=$lib_directory/includes/excludes.txt . ~/$ml4w_directory/$version/ is required."
    exit
fi
echo ":: ML4W Dotfiles $version successfully prepared in ~/$ml4w_directory/$version/"

# Copy hook.tpl if hook.sh not exists
if [ ! -f ~/$ml4w_directory/hook.sh ] ;then
    cp $lib_directory/templates/hook.tpl ~/$ml4w_directory/
    echo ":: hook.tpl created"
else
    chmod +x ~/$ml4w_directory/hook.sh
    echo ":: hook.sh already exists"
fi

# Copy post.tpl if post.sh not exists
if [ ! -f ~/$ml4w_directory/post.sh ] ;then
    cp $lib_directory/templates/post.tpl ~/$ml4w_directory/
    echo ":: post.tpl created"
else
    chmod +x ~/$ml4w_directory/post.sh
    echo ":: post.sh already exists"
fi

# Copy automation.tpl
cp $lib_directory/templates/automation.tpl ~/$ml4w_directory/
echo ":: automation.tpl created"

# Copy activate.sh
cp activate.sh ~/$ml4w_directory/
chmod +x ~/$ml4w_directory/activate.sh
echo ":: activate.sh updated"

# Prepare library folder
cp $lib_directory/includes/scripts.sh ~/$ml4w_directory/library/
echo ":: scripts.sh for $version updated in ~/$ml4w_directory/library"
if [ ! -f ~/$ml4w_directory/library/version.sh ] ;then
    touch ~/$ml4w_directory/library/version.sh
fi
echo "$version" > ~/$ml4w_directory/library/version.sh
echo ":: version.sh updated with $version"

# Write dot folder into settings
echo "$dot_folder" > ~/$ml4w_directory/$version/.config/ml4w/settings/dotfiles-folder.sh