#!/bin/bash
clear

repo="mylinuxforwork/dotfiles"

# Get latest tag from GitHub
get_latest_release() {
  curl --silent "https://api.github.com/repos/$repo/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Get latest zip from GitHub
get_latest_zip() {
  curl --silent "https://api.github.com/repos/$repo/releases/latest" | # Get latest release from GitHub api
    grep '"zipball_url":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Check if package is installed
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Install required packages
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
    "git"
)

latest_version=$(get_latest_release)

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ___           _        _ _           
|_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 | || '_ \/ __| __/ _` | | |/ _ \ '__|
 | || | | \__ \ || (_| | | |  __/ |   
|___|_| |_|___/\__\__,_|_|_|\___|_|   
                                      
EOF
echo "for ML4W Dotfiles"
echo
echo -e "${NONE}"
echo "This script will support you to download and install the ML4W Dotfiles".
echo
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo ":: Installation started."
            echo
        break;;
        [Nn]* ) 
            echo ":: Installation canceled."
            exit;
        break;;
        * ) echo ":: Please answer yes or no.";;
    esac
done

# Create Downloads folder if not exists
if [ ! -d ~/Downloads ] ;then
    mkdir ~/Downloads
    echo ":: Downloads folder created"
fi 

# Remove existing download folder and zip files 
if [ -f $HOME/Downloads/dotfiles-main.zip ] ;then
    rm $HOME/Downloads/dotfiles-main.zip
fi
if [ -f $HOME/Downloads/dotfiles-dev.zip ] ;then
    rm $HOME/Downloads/dotfiles-dev.zip
fi
if [ -f $HOME/Downloads/dotfiles.zip ] ;then
    rm $HOME/Downloads/dotfiles.zip
fi
if [ -d $HOME/Downloads/dotfiles ] ;then
    rm -rf $HOME/Downloads/dotfiles
fi
if [ -d $HOME/Downloads/dotfiles_temp ] ;then
    rm -rf $HOME/Downloads/dotfiles_temp
fi
if [ -d $HOME/Downloads/dotfiles-main ] ;then
    rm -rf $HOME/Downloads/dotfiles-main
fi
if [ -d $HOME/Downloads/dotfiles-dev ] ;then
    rm -rf $HOME/Downloads/dotfiles-dev
fi

# Synchronizing package databases
sudo pacman -Sy
echo

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${packages[@]}";

# Double check rsync
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo

# Select the dotfiles version
echo "Please choose between: "
echo "- ML4W Dotfiles Rolling Release (main branch including the latest commits)"
echo "- ML4W Dotfiles $latest_version (latest tagged release)"
echo
version=$(gum choose "rolling-release" "main-release" "cancel")
if [ "$version" == "main-release" ] ;then
    echo ":: Installing Main Release"
    echo
    git clone --branch $latest_version --depth 1 https://github.com/mylinuxforwork/dotfiles.git ~/Downloads/dotfiles
elif [ "$version" == "rolling-release" ] ;then
    echo ":: Installing Rolling Release"
    echo
    git clone --depth 1 https://github.com/mylinuxforwork/dotfiles.git ~/Downloads/dotfiles
elif [ "$version" == "cancel" ] ;then
    echo ":: Setup canceled"
    exit 130    
else
    echo ":: Setup canceled"
    exit 130
fi

# Check if the clone was successful
if [ $? -ne 0 ] || [ ! -d ~/Downloads/dotfiles ] ; then
    echo ":: Error during cloning the repository. Please check error output and your internet connection."
    exit 1
fi

echo ":: Download complete."

# Change into dotfiles folder
cd $HOME/Downloads/dotfiles
echo ":: Changed into ~/Downloads/dotfiles/"
echo 

# Start Spinner
gum spin --spinner dot --title "Starting the installation now..." -- sleep 3

# Start Installation Script
if [ -f install.sh ] ;then
    ./install.sh
fi
if [ -f ml4w-dotfiles ] ;then
    ./bin/ml4w-dotfiles
fi
