# --------------------------------------------------------------
# Colors
# --------------------------------------------------------------

GREEN='\033[0;32m'
NONE='\033[0m'

# --------------------------------------------------------------
# Check if command exists
# --------------------------------------------------------------

_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

# --------------------------------------------------------------
# Write finish message
# --------------------------------------------------------------

_finishMessage() {
    echo
    echo ":: Installation complete."
    echo ":: Ready to install the dotfiles with the Dotfiles Installer."    
}