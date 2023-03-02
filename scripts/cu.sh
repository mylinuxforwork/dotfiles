#!/bin/bash
 
pacmanUpdates=$(pacman -Syup | grep http:// | wc -l)
aurUpdates=$(yaourt -Qua | grep aur | wc -l)
 
if [ "$pacmanUpdates" -gt 0 ]; then
 updateCount="$pacmanUpdates"
elif [ "$aurUpdates" -gt 0 ]; then
 updateCount="A$aurUpdates"
else
 updateCount=0
fi
 
echo "$updateCount" > /tmp/updateCount
