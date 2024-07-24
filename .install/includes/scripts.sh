# ------------------------------------------------------
# Helper functions for hook and post
# ------------------------------------------------------
version=$(cat library/version.sh)

_protect() {
    echo ":: protect $1"
    if [ -d ~/dotfiles-versions/$version/$1 ] ;then
        rm -rf ~/dotfiles-versions/$version/$1
        echo ":: Folder $1 protected"
    elif [ -f ~/dotfiles-versions/$version/$1 ] ;then
        rm ~/dotfiles-versions/$version/$1
        echo ":: File $1 protected"
    else 
        echo "$1 not found"
    fi
}