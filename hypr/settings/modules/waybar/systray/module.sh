#!/bin/bash
_getHeader "$name" "$author"

echo "Hide or show the systray in ML4W waybar themes."

# Define File
targetFile1="$HOME/dotfiles/waybar/themes/ml4w/config"
targetFile2="$HOME/dotfiles/waybar/themes/ml4w-blur/config"
targetFile3="$HOME/dotfiles/waybar/themes/ml4w-blur-bottom/config"
targetFile4="$HOME/dotfiles/waybar/themes/ml4w-bottom/config"

if [ ! -f $targetFile1 ] || [ ! -f $targetFile2 ] || [ ! -f $targetFile3 ] || [ ! -f $targetFile4 ] ;then
    echo "ERROR: Target file not found."
    sleep 2
    _goBack
fi

# Define Markers
startMarker="\/\/ START TRAY TOOGLE"
endMarker="\/\/ END TRAY TOOGLE"

# Define Replacement Template
customtemplate="VALUE\"tray\","

# Select Value
customvalue=$(gum choose "SHOW" "HIDE")

if [ ! -z $customvalue ]; then
    if [ "$customvalue" == "SHOW" ] ;then
        customvalue=""
    else
        customvalue="//"
    fi
    
    # Replace in Template
    customtext="${customtemplate/VALUE/"$customvalue"}" 

    _replaceInFile $startMarker $endMarker $customtext $targetFile1
    _replaceInFile $startMarker $endMarker $customtext $targetFile2
    _replaceInFile $startMarker $endMarker $customtext $targetFile3
    _replaceInFile $startMarker $endMarker $customtext $targetFile4
    
    # Reload Waybar
    setsid $HOME/dotfiles/waybar/launch.sh 1>/dev/null 2>&1 &
    _goBack
else 
    echo "ERROR: Define a value."
    sleep 2
    _goBack    
fi
