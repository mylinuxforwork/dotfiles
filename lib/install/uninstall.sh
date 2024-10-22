#!/bin/bash
clear
sleep 1
dot_folder=$(cat ~/.config/ml4w/settings/dotfiles-folder.sh)
# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
figlet -f smslant "Uninstaller"
echo "for ML4W Dotfiles"
echo
echo -e "${NONE}"
echo "This script will support you to uninstall the ML4W Dotfiles in ~/$dot_folder from your system."
echo "Only the ML4W Dotfiles related files and folders will be removed."
echo "Packages will not be uninstalled. You have to uninstall packages manually if needed."
echo "Your login manager (display manager) will stay untouched. Please remove it manually if needed."
echo 
if gum confirm "DO YOU WANT TO START THE UNINSTALLATION NOW?" ;then
    echo ":: Uninstallation started."
elif [ $? -eq 130 ]; then
    echo ":: Uninstaller canceled."
    exit 130
else
    echo ":: Uninstaller canceled."
    exit
fi

if gum confirm "DO YOU WANT TO CREATE A BACKUP OF YOUR DOTFILES?" ;then
    rsync -a ~/$dot_folder ~/.ml4w-hyprland/backup/
    echo ":: Backup of $HOME/$dot_folder created in ~/.ml4w-hyprland/backup"
elif [ $? -eq 130 ]; then
    echo ":: Uninstallation canceled."
    exit 130
else
    echo ":: Backup skipped."
fi

if [ ! -z $dot_folder ] ;then
    if [ -f ~/.config/ml4w/settings/dotfiles-folder.sh ] ;then
        rm -rf $HOME/$dot_folder
        echo ":: $HOME/$dot_folder removed"
    fi
fi

if test -L ~/.bashrc ;then
    rm $HOME/.bashrc
fi
if test -L ~/.zshrc ;then
    rm $HOME/.zshrc
fi
if test -L ~/.config/qtile ;then
    rm $HOME/.config/qtile
fi
if test -L ~/.config/hypr ;then
    rm $HOME/.config/hypr
fi
if test -L ~/.config/fastfetch ;then
    rm $HOME/.config/fastfetch
fi
if test -L ~/.config/rofi ;then
    rm $HOME/.config/rofi
fi
if test -L ~/.config/wal ;then
    rm $HOME/.config/wal
fi
if test -L ~/.config/waybar ;then
    rm $HOME/.config/waybar
fi
if test -L ~/.config/wlogout ;then
    rm $HOME/.config/wlogout
fi
if test -L ~/.config/alacritty ;then
    rm $HOME/.config/alacritty
fi
if test -L ~/.config/nvim ;then
    rm $HOME/.config/nvim
fi
if test -L ~/.config/vim ;then
    rm $HOME/.config/vim
fi
if test -L ~/.config/dunst ;then
    rm $HOME/.config/dunst
fi
if test -L ~/.config/swappy ;then
    rm $HOME/.config/swappy
fi
if test -L ~/.config/waypaper ;then
    rm $HOME/.config/waypaper
fi
if test -L ~/.config/ags ;then
    rm $HOME/.config/ags
fi
if test -L ~/.config/kitty ;then
    rm $HOME/.config/kitty
fi
if test -L ~/.config/bashrc ;then
    rm $HOME/.config/bashrc
fi
if test -L ~/.config/zshrc ;then
    rm $HOME/.config/zshrc
fi
if test -L ~/.config/gtk-3.0 ;then
    rm $HOME/.config/gtk-3.0
fi
if test -L ~/.config/gtk-4.0 ;then
    rm $HOME/.config/gtk-4.0
fi
if test -L ~/.config/qt6ct ;then
    rm $HOME/.config/qt6ct
fi
if test -L ~/.config/ml4w ;then
    rm $HOME/.config/ml4w
fi
if test -L ~/.config/ohmyposh ;then
    rm $HOME/.config/ohmyposh
fi
if test -L ~/.config/xsettingsd ;then
    rm $HOME/.config/xsettingsd
fi
echo ":: Symlinks removed"

# Uninstall the ML4W Apps

app_name="com.ml4w.welcome"
if [ -f /usr/share/applications/$app_name.desktop ] ;then
    sudo rm /usr/share/applications/$app_name.desktop
fi
if [ -f /usr/share/icons/hicolor/128x128/apps/$app_name.png ] ;then
    sudo rm /usr/share/icons/hicolor/128x128/apps/$app_name.png
fi
if [ -f /usr/bin/$app_name ] ;then
    sudo rm /usr/bin/$app_name
fi
echo ":: ML4W Welcome App uninstalled successfully"

app_name="com.ml4w.dotfilessettings"
if [ -f /usr/share/applications/$app_name.desktop ] ;then
    sudo rm /usr/share/applications/$app_name.desktop
fi
if [ -f /usr/share/icons/hicolor/128x128/apps/$app_name.png ] ;then
    sudo rm /usr/share/icons/hicolor/128x128/apps/$app_name.png
fi
if [ -f /usr/bin/$app_name ] ;then
    sudo rm /usr/bin/$app_name
fi
echo ":: ML4W Settings App uninstalled successfully"

app_name="com.ml4w.hyprland.settings"
if [ -f /usr/share/applications/$app_name.desktop ] ;then
    sudo rm /usr/share/applications/$app_name.desktop
fi
if [ -f /usr/share/icons/hicolor/128x128/apps/$app_name.png ] ;then
    sudo rm /usr/share/icons/hicolor/128x128/apps/$app_name.png
fi
if [ -f /usr/bin/$app_name ] ;then
    sudo rm /usr/bin/$app_name
fi
echo ":: ML4W Hyprland Settings App uninstalled successfully"

echo ":: ML4W Apps removed"

if gum confirm "DO YOU WANT TO RESTORE OLD CONFIGURATIONS FROM ~/.ml4w-hyprland/backup/config TO ~/.config?" ;then
    rsync -a ~/.ml4w-hyprland/backup/config/ ~/.config/
    echo ":: Old configuration files restored in .config."
elif [ $? -eq 130 ]; then
    echo ":: Uninstaller canceled."
    exit 130
else
    echo ":: .config restore skipped."
fi

if gum confirm "DO YOU WANT TO KEEP ~/.ml4w-hyprland WITH ALL BACKUPS?" ;then
    echo ":: You will find the folder .ml4w-hyprland including your backups in your HOME folder."
elif [ $? -eq 130 ]; then
    echo ":: Uninstaller canceled."
    exit 130
else
    rm -rf $HOME/.ml4w-hyprland
    echo ":: $HOME/.ml4w-hyprland folder removed"
fi

figlet -f smslant "DONE"
echo ":: The ML4W Dotfiles have been removed."
gum spin --spinner dot --title ":: SEE YOU NEXT TIME ;-)" -- sleep 3
