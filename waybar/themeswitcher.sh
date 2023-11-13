#!/bin/bash
#  _____ _                                       _ _       _                
# |_   _| |__   ___ _ __ ___   ___  _____      _(_) |_ ___| |__   ___ _ __  
#   | | | '_ \ / _ \ '_ ` _ \ / _ \/ __\ \ /\ / / | __/ __| '_ \ / _ \ '__| 
#   | | | | | |  __/ | | | | |  __/\__ \\ V  V /| | || (__| | | |  __/ |    
#   |_| |_| |_|\___|_| |_| |_|\___||___/ \_/\_/ |_|\__\___|_| |_|\___|_|    
#                                                                           
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Default theme folder
# ----------------------------------------------------- 
themes_path="$HOME/dotfiles/waybar/themes"

# ----------------------------------------------------- 
# Initialize arrays
# ----------------------------------------------------- 
listThemes=""
listNames=""

# ----------------------------------------------------- 
# Read theme folder
# ----------------------------------------------------- 
options=$(find $themes_path -maxdepth 2 -type d)
for value in $options
do
    if [ ! $value == "$themes_path" ]; then
        if [ $(find $value -maxdepth 1 -type d | wc -l) = 1 ]; then
            result=$(echo $value | sed "s#$HOME/dotfiles/waybar/themes/#/#g")
            IFS='/' read -ra arrThemes <<< "$result"
            listThemes[${#listThemes[@]}]="/${arrThemes[1]};$result"
            if [ -f $themes_path$result/config.sh ]; then
                source $themes_path$result/config.sh
                listNames+="$theme_name\n"
            else
                listNames+="/${arrThemes[1]};$result\n"
            fi
        fi
    fi
done

# ----------------------------------------------------- 
# Show rofi dialog
# ----------------------------------------------------- 
listNames=${listNames::-2}
choice=$(echo -e "$listNames" | rofi -dmenu -replace -config ~/dotfiles/rofi/config-wallpaper.rasi -no-show-icons -width 30 -p "Themes" -format i) 

# ----------------------------------------------------- 
# Set new theme by writing the theme information to ~/.cache/.themestyle.sh
# ----------------------------------------------------- 
if [ "$choice" ]; then
    echo "Loading waybar theme..."
    echo "${listThemes[$choice+1]}" > ~/.cache/.themestyle.sh
    ~/dotfiles/waybar/launch.sh
fi
