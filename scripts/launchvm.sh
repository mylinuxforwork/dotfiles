#!/bin/bash

virsh --connect qemu:///system start win11
echo "Waiting 20 sec for Windows 11 startup..."
sleep 20
echo "Starting xfreerdp now..."
xfreerdp -grab-keyboard /t:"Windows 11" /v:192.168.122.42 /size:100% /d: /p:sancho /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &

exit
