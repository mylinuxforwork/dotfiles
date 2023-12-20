#!/bin/bash
_getHeader "$name" "$author"

# Define File
targetFile="$HOME/dotfiles/waybar/modules.json"

# Define Markers
startMarker="\/\/ START WORKSPACE"
endMarker="\/\/ END WORKSPACES"

# Define Replacement Template
customtemplate="\"*\": VALUE"

# Select Value
customvalue=$(gum choose 5 6 7 8 9 10)
if [ ! -z $customvalue ] ;then
# Replace in Template
customtext="${customtemplate/VALUE/"$customvalue"}" 

# Ensure that markers are in target file
if grep -s "$startMarker" $targetFile && grep -s "$endMarker" $targetFile; then 

    # Write into File
    sed -i '/'"$startMarker"'/,/'"$endMarker"'/ {
    //!d
    /'"$startMarker"'/a\
    '"$customtext"'
    }' $targetFile

    # Reload Waybar
    setsid $HOME/dotfiles/waybar/launch.sh 1>/dev/null 2>&1 &
    _goBack

else 
    echo "ERROR: Marker not found."
    sleep 2
    _goBack
fi
else
    _goBack
fi
