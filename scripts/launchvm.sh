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

function countdown
{
        local OLD_IFS="${IFS}"
        IFS=":"
        local ARR=( $1 )
        local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
        local START=$(date +%s)
        local END=$((START + SECONDS))
        local CUR=$START

        while [[ $CUR -lt $END ]]
        do
                CUR=$(date +%s)
                LEFT=$((END-CUR))

                printf "\r%02d:%02d:%02d" \
                        $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

                sleep 1
        done
        IFS="${OLD_IFS}"
        echo "        "
}

tmp=$(virsh --connect qemu:///system list | grep " win11 " | awk '{ print $3}')
if ([ "x$tmp" == "x" ] || [ "x$tmp" != "xrunning" ])
then
    virsh --connect qemu:///system start win11
    notify-send "Virtual Machine started" "Domain win11"
    echo "Waiting 25 sec for Windows 11 startup..."
    countdown "00:00:25"
else
    notify-send "Virtual Machine already running" "Domain win11"
fi

echo "Starting xfreerdp now..."
xfreerdp -grab-keyboard /t:"Windows 11" /v:192.168.122.42 /size:100% /u:raabe /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &
sleep 10

exit
