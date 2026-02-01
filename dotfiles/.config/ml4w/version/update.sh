#!/usr/bin/env bash
# ------------------------------------------------------
# Check for updates
# ------------------------------------------------------

vercomp() {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i = 0; i < ${#ver1[@]}; i++)); do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

testvercomp() {
    vercomp $1 $2
    case $? in
        0) op='=' ;;
        1) op='>' ;;
        2) op='<' ;;
    esac
    if [[ $op != $3 ]]; then
        # No update available
        echo "1"
    else
        # Update available
        echo "0"
    fi
}

# Get latest tag from GitHub
get_latest_release() {
    local repo="${1:-mylinuxforwork/dotfiles}" # Defaults to the CORRECT repo
    local url="https://api.github.com/repos/$repo/releases/latest"
    
    # Fetch data
    local response=$(curl -s "$url")
    
    # Extract tag (e.g., "v2.9.8")
    local tag=$(echo "$response" | jq -r .tag_name)

    # Validate
    if [ "$tag" == "null" ] || [ -z "$tag" ]; then
        return 1
    fi
    echo "$tag"
}

REMOTE_TAG=$(get_latest_release "mylinuxforwork/dotfiles")
version=$(cat ~/.config/ml4w/version/name)
# testvercomp $version $REMOTE_TAG "<"
testvercomp $version $REMOTE_TAG "<"