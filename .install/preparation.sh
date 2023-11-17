# ------------------------------------------------------
# Prepare dotfiles
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
 ____                                 _   _             
|  _ \ _ __ ___ _ __   __ _ _ __ __ _| |_(_) ___  _ __  
| |_) | '__/ _ \ '_ \ / _` | '__/ _` | __| |/ _ \| '_ \ 
|  __/| | |  __/ |_) | (_| | | | (_| | |_| | (_) | | | |
|_|   |_|  \___| .__/ \__,_|_|  \__,_|\__|_|\___/|_| |_|
               |_|                                      

EOF
echo -e "${NONE}"
echo "Preparing temporary folders for the installation."
echo ""
if [ ! -d ~/dotfiles-versions ]; then
    mkdir ~/dotfiles-versions
    echo "~/dotfiles-versions folder created."
fi
if [ ! -d ~/dotfiles-versions/$version ]; then
    mkdir ~/dotfiles-versions/$version
    echo "~/dotfiles-versions/$version folder created."
else
    echo "The folder ~/dotfiles-versions/$version already exists from previous installations."
    echo ""
    rm -fr ~/dotfiles-versions/$version
    mkdir ~/dotfiles-versions/$version
    echo "Clean build prepared for the installation."
    echo ""
fi
rsync -a --exclude-from=.install/excludes.txt . ~/dotfiles-versions/$version/
echo "dotfiles $version successfully prepared in ~/dotfiles-versions/$version/"
echo ""
