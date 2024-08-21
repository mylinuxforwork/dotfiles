#!/bin/bash
clear
aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
cat <<"EOF"
  ____ _                                
 / ___| | ___  __ _ _ __    _   _ _ __  
| |   | |/ _ \/ _` | '_ \  | | | | '_ \ 
| |___| |  __/ (_| | | | | | |_| | |_) |
 \____|_|\___|\__,_|_| |_|  \__,_| .__/ 
                                 |_|    

EOF

sudo pacman -Rns $(pacman -Qtdq)

$aur_helper -Scc
