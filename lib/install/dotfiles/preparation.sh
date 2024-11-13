# ------------------------------------------------------
# Prepare dotfiles
# ------------------------------------------------------
_writeLogHeader "Preparation"

# Check existing .config folder
if [ ! -d ~/.config ]; then
    mkdir ~/.config
    _writeLog 1 "$HOME/.config folder created."
fi

# Create required folder structure
_writeLog 0 "Preparing temporary folders for the installation."
if [ ! -d $ml4w_directory ] ;then
    mkdir $ml4w_directory
    _writeLog 1 "$ml4w_directory folder created."
fi
if [ ! -d $ml4w_directory/$version ] ;then
    mkdir $ml4w_directory/$version
    _writeLog 1 "$ml4w_directory/$version folder created."
else
    _writeLog 1 "The folder $ml4w_directory/$version already exists from previous installations."
    rm -rf $ml4w_directory/$version
    mkdir $ml4w_directory/$version
    _writeLog 1 "Clean build prepared for the installation."
fi
if [ ! -d $ml4w_directory/library ] ;then
    mkdir $ml4w_directory/library
    _writeLog 1 "library folder created"
fi

# Copy files to the destination
rsync -a -I --exclude-from=$includes_directory/excludes.txt $share_directory/dotfiles/. $ml4w_directory/$version/

# Check copy success
if [[ $(_isFolderEmpty $ml4w_directory/$version/) == 0 ]] ;then
    _writeLogTerminal 2 "AN ERROR HAS OCCURED. Preparation of $ml4w_directory/$version/ failed" 
    _writeLog 2 "Please check that rsync is installad on your system."
    _writeLog 2 "Execution of rsync -a -I --exclude-from=$includes_directory/excludes.txt . $ml4w_directory/$version/ is required."
    exit
fi
_writeLog 1 "ML4W Dotfiles $version successfully prepared in $ml4w_directory/$version/"

# Copy hook.tpl if hook.sh not exists
if [ ! -f $ml4w_directory/hook.sh ] ;then
    cp $template_directory/hook.tpl $ml4w_directory/
    _writeLog 1 "hook.tpl created"
else
    chmod +x $ml4w_directory/hook.sh
    _writeLog 1 "hook.sh already exists"
fi

# Copy post.tpl if post.sh not exists
if [ ! -f $ml4w_directory/post.sh ] ;then
    cp $template_directory/post.tpl $ml4w_directory/
    _writeLog 1 "post.tpl created"
else
    chmod +x $ml4w_directory/post.sh
    _writeLog 1 "post.sh already exists"
fi

# Copy automation.tpl
cp $template_directory/automation.tpl $ml4w_directory/
_writeLog 1 "automation.tpl created"

# Copy activate.sh
cp $install_directory/activate.sh $ml4w_directory/
chmod +x $ml4w_directory/activate.sh
_writeLog 1 "activate.sh updated"

# Prepare library folder
cp $template_directory/scripts.tpl $ml4w_directory/library/scripts.sh
_writeLog 1 "scripts.sh for $version updated in $ml4w_directory/library"

# Replace version
SEARCH="ML4WVERSION"
REPLACE="$version"
sed -i "s/$SEARCH/$REPLACE/g" $ml4w_directory/library/scripts.sh

# Replace ml4w_directory
SEARCH="ML4WDIRECTORY"
REPLACE="$ml4w_directory"
sed -i "s|$SEARCH|$REPLACE|g" $ml4w_directory/library/scripts.sh

# Replace ml4w_aurhelper
SEARCH="ML4WAURHELPER"
REPLACE="$aur_helper"
sed -i "s/$SEARCH/$REPLACE/g" $ml4w_directory/library/scripts.sh

echo "$version" > $ml4w_directory/$version/.config/ml4w/version/name
_writeLog 1 "name updated with $version"

echo "$aur_helper" > $ml4w_directory/$version/.config/ml4w/settings/aur.sh
if [ -f ~/.config/ml4w/settings/aur.sh ] ;then
    rm ~/.config/ml4w/settings/aur.sh
fi
_writeLog 1 "AUR Helper updated with $aur_helper"

# Write dot folder into settings
echo "$dot_folder" > $ml4w_directory/$version/.config/ml4w/settings/dotfiles-folder.sh