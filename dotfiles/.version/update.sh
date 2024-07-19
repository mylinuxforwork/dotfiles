#!/bin/bash

repo="mylinuxforwork/dotfiles"

# Get latest tag from GitHub
get_latest_release() {
  curl --silent "https://api.github.com/repos/$repo/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Calculate version string
calc_latest_version() {
    latest_release=$(get_latest_release "mylinuxforwork/hyprland-dotfiles")
    IFS='.' read -r -a array <<< "$latest_release"

    # version pos 1
    v1="${array[0]}"

    # version pos 2
    v2="${array[1]}"
    l2=${#v2}
    if [ $l2 -eq 1 ] ;then
        v2="00$v2"
    elif [ $l2 -eq 2 ] ;then    
        v2="0$v2"
    fi

    # version pos 3
    v3="${array[2]}"
    l3=${#v3}
    if [ $l3 -eq 1 ] ;then
        v3="00$v3"
    elif [ $l3 -eq 2 ] ;then    
        v3="0$v3"
    fi

    echo "$v1$v2$v3"
}

# Check for internet connection
if ping -q -c 1 -W 1 google.com >/dev/null; then

    version=$(cat ~/dotfiles/.version/version)
    online=$(calc_latest_version)
    if [ $((version)) -lt $((online)) ]; then
        # Update available
        echo "0"
    else
        # No update available
        echo "1"
    fi
else
    # Network is down
    echo "1"
fi