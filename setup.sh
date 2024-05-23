#!/bin/bash
clear

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
            echo "${pkg} is already installed.";
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
)

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
            echo "Installation started."
            echo
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Synchronizing package databases
sudo pacman -Sy
echo

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${packages[@]}";
echo

# Double check rsync
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo

# Select the dotfiles version
echo "Please choose between the main-release or the rolling-release (development version):"
version=$(gum choose "main-release" "rolling-release")
if [ "$version" == "main-release" ] ;then
    wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/main/dotfiles-main.zip
    v="main"
elif [ "$version" == "rolling-release" ] ;then
    wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/dev/dotfiles-dev.zip
    v="dev"
else
    exit 130
fi
echo ":: Download complete."
echo

# Unzip
unzip -o -q ~/Downloads/dotfiles-$v.zip -d ~/Downloads/
echo ":: Unzip complete."
cd $HOME/Downloads/dotfiles-$v
echo ":: Changed into ~/Downloads/dotfiles-$v/"

# Start the installatiom
if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
    echo
    echo "Starting the installation now..."
    sleep 2
    ./install.sh
elif [ $? -eq 130 ]; then
        exit 130
else
    echo "Installation canceled."
    echo "You can start the installation manually with ~/Downloads/dotfiles-$version/install.sh"
    exit;
fi