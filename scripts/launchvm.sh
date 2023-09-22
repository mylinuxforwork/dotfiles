#!/bin/bash
#  _                           _      __     ____  __  
# | |    __ _ _   _ _ __   ___| |__   \ \   / /  \/  | 
# | |   / _` | | | | '_ \ / __| '_ \   \ \ / /| |\/| | 
# | |__| (_| | |_| | | | | (__| | | |   \ V / | |  | | 
# |_____\__,_|\__,_|_| |_|\___|_| |_|    \_/  |_|  |_| 
#                                                      
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

if [ -f ~/private/win11-credentials.sh ]; then
    echo "Credential file exists. Using the file."
    source ~/private/win11-credentials.sh
else
    win11user="USER"
    win11pass="PASS"
fi

tmp=$(virsh --connect qemu:///system list | grep " win11 " | awk '{ print $3}')

if ([ "x$tmp" == "x" ] || [ "x$tmp" != "xrunning" ])
then
    virsh --connect qemu:///system start win11
    echo "Virtual Machine win11 is starting... Waiting 45s for booting up."
    notify-send "Virtual Machine win11 is starting..." "Waiting 45s for booting up."
    sleep 45
else
    notify-send "Virtual Machine win11 is already running." "Launching xfreerdp now!"
    echo "Starting xfreerdp now..."
fi

xfreerdp -grab-keyboard /v:192.168.122.44 /size:100% /cert-ignore /u:$win11user /p:$win11pass /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &
