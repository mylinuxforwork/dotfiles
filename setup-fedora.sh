#!/usr/bin/env bash
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
    grep '"tag_name":' |                                               # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                       # Pluck JSON value
}

# Get latest zip from GitHub
get_latest_zip() {
  curl --silent "https://api.github.com/repos/$repo/releases/latest" | # Get latest release from GitHub api
    grep '"zipball_url":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                       # Pluck JSON value
}

# Check if package is installed
_isInstalled() {
    package="$1";
    check=$(yum list installed | grep $package)
    if [ -z "$check" ]; then
        echo 1; #'1' means 'false' in Bash
        return; #false
    else
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi
}

# Install required packages
_installPackages() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]]; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo dnf install --assumeyes "${toInstall[@]}"
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "rsync"
    "git"
    "figlet"
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
            echo ":: Installation started"
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

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackages "${packages[@]}";

bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/share/packages/fedora/special/gum.sh)

echo
# Select the dotfiles version
echo "Please choose between: "
echo "- ML4W Dotfiles for Hyprland $latest_version (latest stable release)"
echo "- ML4W Dotfiles for Hyprland Rolling Release (main branch including the latest commits)"
echo
version=$(gum choose "main-release" "rolling-release" "cancel")
if [ "$version" == "main-release" ]; then
    echo ":: Installing Main Release"
    echo
    git clone --branch $latest_version --depth 1 https://github.com/mylinuxforwork/dotfiles.git $download_folder/dotfiles
elif [ "$version" == "rolling-release" ]; then
    echo ":: Installing Rolling Release"
    echo
    git clone --depth 1 https://github.com/mylinuxforwork/dotfiles.git $download_folder/dotfiles
elif [ "$version" == "cancel" ]; then
    echo ":: Setup canceled"
    exit 130
else
    echo ":: Setup canceled"
    exit 130
fi
echo ":: Download complete."
echo
# Cd into dotfiles folder
cd $download_folder/dotfiles/bin/

# Start Spinner
gum spin --spinner dot --title "Starting the installation now..." -- sleep 3

# Start installation
./ml4w-hyprland-setup -m install
echo

# Start Spinner
gum spin --spinner dot --title "Starting the setup now..." -- sleep 3

# Start setup
./ml4w-hyprland-setup -p fedora
