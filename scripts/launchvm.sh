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

tmp=$(virsh --connect qemu:///system list | grep " win11 " | awk '{ print $3}')
if ([ "x$tmp" == "x" ] || [ "x$tmp" != "xrunning" ])
then
    virsh --connect qemu:///system start win11
    echo "Virtual Machine win11 is starting..."
    exit
else
    echo "Starting xfreerdp now..."
    xfreerdp -grab-keyboard /t:"Windows 11" /v:192.168.122.42 /size:100% /u:raabe /p:SECRET /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &
    exit
fi

