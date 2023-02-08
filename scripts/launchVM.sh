#!/bin/bash

virsh --connect qemu:///system start RDPWindows
echo "Waiting 30 sec for Windows 10 startup..."
sleep 30
echo "Starting xfreerdp now..."
xfreerdp /v:Windows10 /size:100% /d: /p:sancho /dynamic-resolution &


