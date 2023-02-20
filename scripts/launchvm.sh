#!/bin/bash

virsh --connect qemu:///system start win11
echo "Waiting 30 sec for Windows 11 startup..."
sleep 30
echo "Starting xfreerdp now..."
xfreerdp /v:192.168.122.42 /size:100% /d: /p:sancho /dynamic-resolution &

exit
