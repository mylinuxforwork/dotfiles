#!/bin/bash
#  _                _    _                ____ _                
# | |    ___   ___ | | _(_)_ __   __ _   / ___| | __ _ ___ ___  
# | |   / _ \ / _ \| |/ / | '_ \ / _` | | |  _| |/ _` / __/ __| 
# | |__| (_) | (_) |   <| | | | | (_| | | |_| | | (_| \__ \__ \ 
# |_____\___/ \___/|_|\_\_|_| |_|\__, |  \____|_|\__,_|___/___/ 
#                                |___/                          
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

tmp=$(virsh --connect qemu:///system list | grep " win11 " | awk '{ print $3}')
if ([ "x$tmp" == "x" ] || [ "x$tmp" != "xrunning" ])
then
    virsh --connect qemu:///system start win11
    echo "Virtual Machine win11 is starting..."
    sleep 3
fi
looking-glass-client &
exit
