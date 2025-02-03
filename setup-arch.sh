#!/bin/bash
clear

# ----------------------------------------------------- 
# Repository
# -----------------------------------------------------
repo="mylinuxforwork/dotfiles"

# ----------------------------------------------------- 
# Download Folder
# -----------------------------------------------------
download_folder="$HOME/.ml4w"

# Create download_folder if not exists
if [ ! -d $download_folder ]; then
    mkdir -p $download_folder
fi

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
_isInstalled() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Check if command exists
_checkCommandExists() {
    package="$1";
	if ! command -v $package > /dev/null; then
        return 1
    else
        return 0
    fi
}

# Install required packages
_installPackages() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]]; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

# install yay if needed
_installYay() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git $download_folder/yay
    cd $download_folder/yay
    makepkg -si
    cd $temp_path
    echo ":: yay has been installed successfully."
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
   ____         __       ____       
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/   
                                    
EOF
echo "ML4W Dotfiles for Hyprland"
echo -e "${NONE}"
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo ":: Installation started."
            echo
        break;;
        [Nn]* ) 
            echo ":: Installation canceled"
            exit;
        break;;
        * ) 
            echo ":: Please answer yes or no."
        ;;
    esac
done

# Create Download folder if not exists
if [ ! -d $download_folder ]; then
    mkdir -p $download_folder
    echo ":: $download_folder folder created"
fi 

# Remove existing download folder and zip files 
if [ -f $download_folder/dotfiles-main.zip ]; then
    rm $download_folder/dotfiles-main.zip
fi
if [ -f $download_folder/dotfiles-dev.zip ]; then
    rm $download_folder/dotfiles-dev.zip
fi
if [ -f $download_folder/dotfiles.zip ]; then
    rm $download_folder/dotfiles.zip
fi
if [ -d $download_folder/dotfiles ]; then
    rm -rf $download_folder/dotfiles
fi
if [ -d $download_folder/dotfiles_temp ]; then
    rm -rf $download_folder/dotfiles_temp
fi
if [ -d $download_folder/dotfiles-main ]; then
    rm -rf $download_folder/dotfiles-main
fi
if [ -d $download_folder/dotfiles-dev ]; then
    rm -rf $download_folder/dotfiles-dev
fi

# Synchronizing package databases
sudo pacman -Sy
echo

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
    echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    sudo pacman -Syyu
    sudo pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackages "${packages[@]}";

# Install yay if needed
if _checkCommandExists "yay"; then
    echo ":: yay is already installed"
else
    echo ":: The installer requires yay. yay will be installed now"
    _installYay
fi
echo

# Select the dotfiles version
echo "Please choose between: "
echo "- ML4W Dotfiles for Hyprland $latest_version (latest stable release)"
echo "- ML4W Dotfiles for Hyprland Rolling Release (main branch including the latest commits)"
echo
version=$(gum choose "main-release" "rolling-release" "CANCEL")
if [ "$version" == "main-release" ]; then
    echo ":: Installing Main Release"
    yay -S --noconfirm ml4w-hyprland
elif [ "$version" == "rolling-release" ]; then
    echo ":: Installing Rolling Release"
    yay -S ml4w-hyprland-git
elif [ "$version" == "CANCEL" ]; then
    echo ":: Setup canceled"
    exit 130    
else
    echo ":: Setup canceled"
    exit 130
fi
echo ":: Installation complete."
echo
# Start Spinner
gum spin --spinner dot --title "Starting setup now..." -- sleep 3

# Start setup
ml4w-hyprland-setup -p arch
