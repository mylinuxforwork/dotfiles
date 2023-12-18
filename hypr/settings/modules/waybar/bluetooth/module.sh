#!/bin/bash
_getHeader "$name" "$author"

echo "Hide the bluetooth icon in waybar."

# Define File
targetFile="$HOME/dotfiles/waybar/themes/ml4w/config"

if [ ! -f $targetFile ] ;then
    echo "ERROR: Target file not found."
    sleep 2
    _goBack
fi

# Define Markers
startMarker="\/\/ START BT TOOGLE"
endMarker="\/\/ END BT TOOGLE"

# Define Replacement Template
customtemplate="VALUE\"bluetooth\","

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

    # Ensure that markers are in target file
    if grep -s "$startMarker" $targetFile && grep -s "$endMarker" $targetFile; then 

        # Write into File
        sed -i '/'"$startMarker"'/,/'"$endMarker"'/ {
        //!d
        /'"$startMarker"'/a\
        '"$customtext"'
        }' $targetFile

        # Reload Waybar
        $HOME/dotfiles/waybar/launch.sh 1>/dev/null 2>&1
        _goBack

    else 
        echo "ERROR: Marker not found."
        sleep 2
        _goBack
    fi
else 
    echo "ERROR: Define a value."
    sleep 2
    _goBack    
fi
