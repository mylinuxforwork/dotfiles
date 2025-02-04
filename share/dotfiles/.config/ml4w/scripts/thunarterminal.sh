#!/bin/bash
clear
if [ -f ~/.config/ml4w/settings/terminal.sh ]; then
    terminal="$(cat ~/.config/ml4w/settings/terminal.sh)"
    echo ":: Installing $terminal"
    if [ -d ~/.config/xfce4 ]; then
        if [ ! -f ~/.config/xfce4/helpers.rc ]; then
            touch ~/.config/xfce4/helpers.rc
        fi
        echo "TerminalEmulator=$terminal" >~/.config/xfce4/helpers.rc
        echo ":: $terminal defined as Thunar Terminal Emulator."
    else
        echo "ERROR: ~/.config/xfce4 not found. Please open Thunar once to create it."
        echo "Then start this script again."
    fi
else
    echo "ERROR: ~/.config/ml4w/settings/terminal.sh not found"
fi
sleep 3
