#!/usr/bin/env bash
_writeLogHeader "SDDM Theme"

sddm_theme_name="sequoia"
sddm_theme_master="main.zip"
sddm_theme_folder="sddm-sequoia"
sddm_theme_download="https://codeberg.org/minMelody/sddm-sequoia/archive/main.zip"
sddm_asset_folder="/usr/share/sddm/themes/$sddm_theme_name/backgrounds"
# sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sequoia

sddm_theme_tpl="$share_directory/sddm/theme.conf"

if [ -z $automation_displaymanager ]; then
    if [ -d /usr/share/sddm ]; then
        _writeHeader "SDDM Theme"
        if gum confirm "Do you want to install/update the $sddm_theme_name theme?" ;then
            _writeLog 0 "Installing $sddm_theme_name"

            if [ -d $download_folder/$sddm_theme_name ]; then
                rm -rf $download_folder/$sddm_theme_name
                _writeLog 1 "$download_folder/$sddm_theme_name removed"
            fi 

            wget -P $download_folder/$sddm_theme_name $sddm_theme_download &>> $(_getLogFile)
            _writeLog 1 "Download of $sddm_theme_name complete"
            unzip -o -q $download_folder/$sddm_theme_name/$sddm_theme_master -d $download_folder/$sddm_theme_name &>> $(_getLogFile)
            _writeLog 1 "Unzip of $sddm_theme_name complete"

            sudo cp -r $download_folder/$sddm_theme_name/$sddm_theme_folder /usr/share/sddm/themes/$sddm_theme_name
            _writeLog 1 "$sddm_theme_name copied to target location"

            if [ ! -d /etc/sddm.conf.d/ ]; then
                sudo mkdir /etc/sddm.conf.d
                _writeLog 1 "Folder /etc/sddm.conf.d created."
            fi

            sudo cp $share_directory/sddm/sddm.conf /etc/sddm.conf.d/
            _writeLog 1 "File /etc/sddm.conf.d/sddm.conf updated."

            if [ -f /usr/share/sddm/themes/$sddm_theme_name/theme.conf ]; then

                # Cache file for holding the current wallpaper
                sudo cp $wallpaper_directory/default.jpg $sddm_asset_folder/current_wallpaper.jpg
                _writeLog 1 "Default wallpaper copied into $sddm_asset_folder"

                sudo cp $sddm_theme_tpl /usr/share/sddm/themes/$sddm_theme_name/
                sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.jpg"'/' /usr/share/sddm/themes/$sddm_theme_name/theme.conf
                _writeLog 1 "File theme.conf updated in /usr/share/sddm/themes/$sddm_theme_name/"
            fi
            _writeLogTerminal 1 "Theme installed"
        fi
    else
        _writeLog 2 "SDDM (/usr/share/sddm) not found"
    fi
else
    if [[ "$automation_displaymanager" = true ]]; then
        _writeLog 0 "AUTOMATION: Keep current theme of Display Manager"
    fi
fi
