#!/bin/bash
#      _       _    __ _ _           
#   __| | ___ | |_ / _(_) | ___  ___ 
#  / _` |/ _ \| __| |_| | |/ _ \/ __|
# | (_| | (_) | |_|  _| | |  __/\__ \
#  \__,_|\___/ \__|_| |_|_|\___||___/
#                                    
# by Stephan Raabe (2023)
# ------------------------------------------------------
# Install Script for dotfiles and configuration
# yay must be installed
# ------------------------------------------------------

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
clear
echo "     _       _    __ _ _            "
echo "  __| | ___ | |_ / _(_) | ___  ___  "
echo " / _' |/ _ \| __| |_| | |/ _ \/ __| "
echo "| (_| | (_) | |_|  _| | |  __/\__ \ "
echo " \__,_|\___/ \__|_| |_|_|\___||___/ "
echo "                                    "
echo "by Stephan Raabe (2023)"
echo "-------------------------------------"
echo ""

while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo ""
echo "-> Install main packages"

packagesPacman=("alacritty" "scrot" "nitrogen" "picom" "starship" "slock" "neomutt" "neovim" "rofi" "dunst" "ueberzug" "mpv" "freerdp" "spotifyd" "xfce4-power-manager" "python-pip" "thunar" "mousepad" "papirus-icon-theme" "ttf-font-awesome" "ttf-fira-sans" "ttf-fira-code" "ttf-firacode-nerd" "figlet" "cmatrix" "lxappearance" "qalculate-gtk" "pop-gtk-theme" "polybar" "chromium");

packagesYay=("brave-bin" "timeshift" "pfetch" "preload" "bibata-cursor-theme");

packagesPip=("psutil" "rich" "click");
    
# ------------------------------------------------------
# Function: Is package installed
# ------------------------------------------------------
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

_isInstalledYay() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_isInstalledPip() {
    package="$1";
    check="$(pip list | grep "${package} ")";
    if [ -n "${check}" ] ; then
      echo 0;
    else
      echo 1;
    fi
}

# ------------------------------------------------------
# Function Install all package if not installed
# ------------------------------------------------------
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

    printf "Packages not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman -S "${toInstall[@]}";
}

_installPackagesYay() {
    toInstall=();

    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;

        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    printf "AUR ackages not installed:\n%s\n" "${toInstall[@]}";
    yay -S "${toInstall[@]}";
}

_installPackagesPip() {
    toInstall=();

    for pkg; do
        if [[ $(_isInstalledPip "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;

        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    printf "Pip packages not installed:\n%s\n" "${toInstall[@]}";
    pip install "${toInstall[@]}";
}

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";
_installPackagesPip "${packagesPip[@]}";

# pywal requires dedicated installation
yay -S pywal

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
sudo systemctl enable preload

# ------------------------------------------------------
# Create .config folder
# ------------------------------------------------------
echo ""
echo "-> Install .config folder"

if [ -d ~/.config ]; then
    echo ".config folder already exists."
else
    mkdir ~/.config
    echo ".config folder created."
fi

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo ""
echo "-> Install symbolic links"

_installSymLink() {
    symlink="$1";
    linksource="$2";
    linktarget="$3";
    if [ -L "${symlink}" ]; then
        echo "Link ${symlink} exists already."
    else
        if [ -d ${symlink} ]; then
            echo "Directory ${symlink}/ exists."
        else
            if [ -f ${symlink} ]; then
                echo "File ${symlink} exists."
            else
                ln -s ${linksource} ${linktarget} 
                echo "Link ${linksource} -> ${linktarget} created."
            fi
        fi
    fi
}

_installSymLink ~/.config/qtile ~/dotfiles/qtile/ ~/.config
_installSymLink ~/.config/alacritty ~/dotfiles/alacritty/ ~/.config
_installSymLink ~/.config/neomutt ~/dotfiles/neomutt/ ~/.config
_installSymLink ~/.config/picom ~/dotfiles/picom/ ~/.config
_installSymLink ~/.config/ranger ~/dotfiles/ranger/ ~/.config
_installSymLink ~/.config/rofi ~/dotfiles/rofi/ ~/.config
_installSymLink ~/.config/spotifyd ~/dotfiles/spotifyd/ ~/.config
_installSymLink ~/.config/vim ~/dotfiles/vim/ ~/.config
_installSymLink ~/.config/nvim ~/dotfiles/nvim/ ~/.config
_installSymLink ~/.config/polybar ~/dotfiles/polybar/ ~/.config
_installSymLink ~/.config/dunst ~/dotfiles/dunst/ ~/.config
_installSymLink ~/.config/starship.toml ~/dotfiles/starship/starship.toml ~/.config/starship.toml

# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo ""
echo "-> Install .bashrc"
while true; do
    read -p "Do you want to replace the existing .bashrc file? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            rm ~/.bashrc
            echo ".bashrc removed"
        break;;
        [Nn]* ) 
            echo "Replacement of .bashrc skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
_installSymLink ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc

# ------------------------------------------------------
# Install Theme, Icons and Cursor
# ------------------------------------------------------
echo ""
echo "-> Install Theme"
while true; do
    read -p "Do you want to replace the existing theme configuration? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            rm ~/.gtkrc-2.0
            rm -r ~/.config/gtk-3.0
            rm ~/.Xresources
            rm -r ~/.icons
            echo "Existing theme removed"
        break;;
        [Nn]* ) 
            echo "Replacement of theme skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
_installSymLink ~/.gtkrc-2.0 ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0
_installSymLink ~/.config/gtk-3.0 ~/dotfiles/gtk-3.0/ ~/.config/
_installSymLink ~/.Xresources ~/dotfiles/.Xresources ~/.Xresources
_installSymLink ~/.icons ~/dotfiles/.icons/ ~/

# ------------------------------------------------------
# Clone wallpapers
# ------------------------------------------------------
echo ""
echo "-> Install wallpapers (into folder ~/wallpaper)"
if [ -d ~/wallpaper/ ]; then
    echo "wallpaper folder already exists."
else
    git clone https://gitlab.com/stephan-raabe/wallpaper.git ~/wallpaper
    echo "wallpaper installed."
fi

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
echo ""
echo "-> Init pywal"
wal -i ~/wallpaper/default.jpg -n
echo "pywal initiated."

# ------------------------------------------------------
# Install custom issue (login prompt)
# ------------------------------------------------------
echo ""
echo "-> Install login screen"
while true; do
    read -p "Do you want to install the custom login promt? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            sudo cp ~/dotfiles/issue /etc/issue
            echo "Login promt installed."
        break;;
        [Nn]* ) 
            echo "Custom login promt skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# DONE
# ------------------------------------------------------
echo ""
echo "DONE! Reboot suggested..."
