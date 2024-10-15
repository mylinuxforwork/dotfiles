# ------------------------------------------------------
# Disable display manager
# ------------------------------------------------------

echo -e "${GREEN}"
figlet -f smslant "Display Manager"
echo -e "${NONE}"

if [ -z $automation_displaymanager ] ;then
    if [ -f /etc/systemd/system/display-manager.service ]; then
        disman=0
        echo "You have already installed a display manager. If your display manager is working fine, you can keep the current setup."
        echo "How do you want to proceed?"
        echo
        dmsel=$(gum choose "Keep current setup" "Deactivate current display manager" "Install sddm and theme")
    else
        disman=1
        echo "There is no display manager installed on your system. You're starting Hyprland/Qtile with commands on tty."
        echo "How do you want to proceed?"
        echo
        dmsel=$(gum choose "Keep current setup" "Install sddm and theme")
    fi

    if [ -z "${dmsel}" ] ;then
        echo ":: Installation canceled."
        exit
    fi
    if [ "$dmsel" == "Install sddm and theme" ] ;then

        if [ -d /usr/share/sddm/themes/sugar-candy/ ] ;then
            sudo rm -rf /usr/share/sddm/themes/sugar-candy/
            echo ":: Sugar Candy folder removed"
        fi

        disman=0
        # Try to force the installation of sddm
        echo ":: Installing sddm"
        sudo pacman -S --noconfirm --needed sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg --ask 4
        
        # Enable sddm
        if [ -f /etc/systemd/system/display-manager.service ]; then
            sudo rm /etc/systemd/system/display-manager.service
        fi
        sudo systemctl enable sddm.service

        echo 
        if gum confirm "Do you want to install the sddm-sugar-candy theme?" ;then
            echo ":: Installing sddm-sugar-candy-git"

            if [ -d ~/Downloads/sddm-sugar-candy ] ;then
                rm -rf ~/Downloads/sddm-sugar-candy
                echo ":: ~/Downloads/sddm-sugar-candy removed"
            fi 
            wget -P ~/Downloads/sddm-sugar-candy https://github.com/Kangie/sddm-sugar-candy/archive/refs/heads/master.zip
            echo ":: Download of sddm-sugar-candy complete"
            unzip -o -q ~/Downloads/sddm-sugar-candy/master.zip -d ~/Downloads/sddm-sugar-candy
            echo ":: Unzip of sddm-sugar-candy complete"
            sudo cp -r ~/Downloads/sddm-sugar-candy/sddm-sugar-candy-master /usr/share/sddm/themes/sugar-candy
            echo ":: sddm-sugar-candy copied to target location"

            if [ ! -d /etc/sddm.conf.d/ ]; then
                sudo mkdir /etc/sddm.conf.d
                echo "Folder /etc/sddm.conf.d created."
            fi

            sudo cp $dotfiles_directory/.config/ml4w/sddm/sddm.conf /etc/sddm.conf.d/
            echo "File /etc/sddm.conf.d/sddm.conf updated."

            if [ -f /usr/share/sddm/themes/sugar-candy/theme.conf ]; then

                # Cache file for holding the current wallpaper
                sudo cp $wallpaper_directory/default.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/current_wallpaper.jpg
                echo "Default wallpaper copied into /usr/share/sddm/themes/sugar-candy/Backgrounds/"

                sudo cp $dotfiles_directory/.config/ml4w/sddm/theme.conf /usr/share/sddm/themes/sugar-candy/
                sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.jpg"'/' /usr/share/sddm/themes/sugar-candy/theme.conf
                echo "File theme.conf updated in /usr/share/sddm/themes/sugar-candy/"

            fi
        fi

    elif [ "$dmsel" == "Deactivate current display manager" ] ;then

        sudo rm /etc/systemd/system/display-manager.service
        echo ":: Current display manager deactivated."
        disman=1

    elif [ "$dmsel" == "Keep current setup" ] ;then
        echo ":: sddm setup skipped."
    else
        echo ":: sddm setup skipped."
    fi
else
    if [[ "$automation_displaymanager" = true ]] ;then
        echo ":: AUTOMATION: Keep current setup of Display Manager"
        disman=0
    fi
fi