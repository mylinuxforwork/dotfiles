# ------------------------------------------------------
# Prepare dotfiles
# ------------------------------------------------------

cat <<"EOF"
 ____                                 _   _             
|  _ \ _ __ ___ _ __   __ _ _ __ __ _| |_(_) ___  _ __  
| |_) | '__/ _ \ '_ \ / _` | '__/ _` | __| |/ _ \| '_ \ 
|  __/| | |  __/ |_) | (_| | | | (_| | |_| | (_) | | | |
|_|   |_|  \___| .__/ \__,_|_|  \__,_|\__|_|\___/|_| |_|
               |_|                                      

EOF

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
    echo "The folder ~/dotfiles-versions/$version already exists."
    echo "Do you want to create a clean build of version $version and "
    while true; do
        read -p "and replace all files? (Yy/Nn): " yn
        case $yn in
            [Yy]* )
                rm -fr ~/dotfiles-versions/$version
                mkdir ~/dotfiles-versions/$version
            break;;
            [Nn]* ) 
            break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo ""
fi            
cp -rf . ~/dotfiles-versions/$version/

if [ -d ~/dotfiles-versions/$version/.git ]; then
    rm -rf ~/dotfiles-versions/$version/.git
fi

if [ -f ~/dotfiles-versions/$version/.gitignore ]; then
    rm ~/dotfiles-versions/$version/.gitignore
fi

if [ -f ~/dotfiles-versions/$version/CHANGELOG ]; then
    rm ~/dotfiles-versions/$version/CHANGELOG
fi

if [ -f ~/dotfiles-versions/$version/README.md ]; then
    rm ~/dotfiles-versions/$version/README.md
fi

if [ -f ~/dotfiles-versions/$version/install.sh ]; then
    rm ~/dotfiles-versions/$version/install.sh
fi

if [ -d ~/dotfiles-versions/$version/.install ]; then
    rm -rf ~/dotfiles-versions/$version/.install
fi

echo "dotfiles $version successfully prepared in ~/dotfiles-versions/$version/"
echo ""
