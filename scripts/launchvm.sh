#!/bin/bash

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

virsh --connect qemu:///system start win11
echo "Waiting 20 sec for Windows 11 startup..."
countdown "00:00:20"

echo "Starting xfreerdp now..."
xfreerdp -grab-keyboard /t:"Windows 11" /v:192.168.122.42 /size:100% /d: /p:sancho /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &
sleep 10

exit
