if [ $install_platform = "arch" ]; then
    echo
    echo ":: The latest Arch Updates include a new Python version."
    echo ":: This requires the rebuild of waypaper python-screeninfo python-imageio."
    echo
    if gum confirm "Do you want to run cleanbuild now?"; then

        _writeLogTerminal 0 "Start rebuilding ..."
        if [ $aur_helper = "yay" ]; then
            $aur_helper -S --answerclean All --noconfirm --rebuildall waypaper python-screeninfo python-imageio &>> $(_getLogFile)
        fi
        if [ $aur_helper = "paru" ]; then
            $aur_helper -S --rebuild=all --noconfirm waypaper python-screeninfo python-imageio &>> $(_getLogFile)
        fi
    fi
fi
