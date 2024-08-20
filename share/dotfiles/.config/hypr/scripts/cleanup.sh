#!/bin/bash
#   ____ _                              
#  / ___| | ___  __ _ _ __  _   _ _ __  
# | |   | |/ _ \/ _` | '_ \| | | | '_ \ 
# | |___| |  __/ (_| | | | | |_| | |_) |
#  \____|_|\___|\__,_|_| |_|\__,_| .__/ 
#                                |_|   
# 

# Remove gamemode flag
if [ -f ~/.cache/gamemode ] ;then
    rm ~/.cache/gamemode
    echo ":: ~/.cache/gamemode removed"
fi