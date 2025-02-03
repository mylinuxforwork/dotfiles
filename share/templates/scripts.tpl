# ------------------------------------------------------
# Helper functions for hook and post
# ------------------------------------------------------
version="ML4WVERSION"
ml4w_directory="ML4WDIRECTORY"

# ------------------------------------------------------
# Protect files or folder from been overwritten by an update
# ------------------------------------------------------
_protect() {
    echo ":: protect $1"
    if [ -d $ml4w_directory/$version/$1 ]; then
        rm -rf $ml4w_directory/$version/$1
        echo ":: Folder $1 protected"
    elif [ -f $ml4w_directory/$version/$1 ]; then
        rm $ml4w_directory/$version/$1
        echo ":: File $1 protected"
    else 
        echo "$1 not found"
    fi
}