#!/bin/bash
#  _____ _                     _     _  __ _   
# |_   _(_)_ __ ___   ___  ___| |__ (_)/ _| |_ 
#   | | | | '_ ` _ \ / _ \/ __| '_ \| | |_| __|
#   | | | | | | | | |  __/\__ \ | | | |  _| |_ 
#   |_| |_|_| |_| |_|\___||___/_| |_|_|_|  \__|
#                                              

sleep 1
clear
figlet "Timeshift"

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

if [[ $(_isInstalledYay "timeshift") == "0" ]] ;then
    echo ":: Timeshift is already installed"
    sleep 3
else
    if gum confirm "DO YOU WANT TO INSTALL Timeshift now?" ;then
        yay -S timeshift
    fi
fi