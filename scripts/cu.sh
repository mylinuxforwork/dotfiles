#!/bin/bash
#  _   _           _       _             
# | | | |_ __   __| | __ _| |_ ___  ___  
# | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
# | |_| | |_) | (_| | (_| | ||  __/\__ \ 
#  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#       |_|                              
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

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
