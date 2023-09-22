#/bin/sh
#  _____ _ _                                                   
# |  ___(_) | ___ _ __ ___   __ _ _ __   __ _  __ _  ___ _ __  
# | |_  | | |/ _ \ '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__| 
# |  _| | | |  __/ | | | | | (_| | | | | (_| | (_| |  __/ |    
# |_|   |_|_|\___|_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|    
#                                             |___/            
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

if [ -f "/usr/bin/nautilus" ]; then
    echo "nautilus is installed."
    nautilus --new-window
else
    echo "nautilus not installed. Launching thunar instead."
    thunar
fi;
