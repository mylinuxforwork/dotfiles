#!/bin/bash
_writeLogHeader "SDDM Theme"
sddm_theme_name="sequoia"
if [ -d /usr/share/sddm/themes/$sddm_theme_name ]; then
    _writeHeader "Restore SDDM Theme"
    _writeMessage "SDDM Themes are not shipped with the dotfiles anymore due to compatibility reasons."
    _writeMessage "Please install themes for your display manager individually."
    echo
    if gum confirm "Do you want to restore the standard SDDM and remove Sequoia theme?"; then
        sudo cp $share_directory/sddm/sddm.conf /etc/sddm.conf.d/
        _writeMessage "File /etc/sddm.conf.d/sddm.conf updated."

        sudo rm -rf /usr/share/sddm/themes/$sddm_theme_name
        _writeMessage "Sequoia theme removed"                
    fi
fi
