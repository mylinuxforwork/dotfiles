#!/bin/bash
#  ____                        _           _    
# / ___| _ __   __ _ _ __  ___| |__   ___ | |_  
# \___ \| '_ \ / _` | '_ \/ __| '_ \ / _ \| __| 
#  ___) | | | | (_| | |_) \__ \ | | | (_) | |_  
# |____/|_| |_|\__,_| .__/|___/_| |_|\___/ \__| 
#                   |_|                         
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

c=$(gum input --placeholder "Enter a comment for the snapshot...")
sudo timeshift --create --comments "$c"
sudo timeshift --list
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "DONE. Snapshot $c created!"
