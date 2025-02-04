# ------------------------------------------------------
# Diagnosis
# ------------------------------------------------------
_writeLogHeader "Diagnosis"

commands=(
    "waybar"
    "hyprpaper"
    "hyprlock"
    "hypridle"
    "hyprshade"
    "wal"
    "gum"
    "wlogout"
    "magick"
    "waypaper"
)

missing_commands=""

_run_diagnosis() {
    for command in "${commands[@]}"; do
        if ! _checkCommandExists $command; then
            missing_commands+="$command "
        fi
    done
}

_run_diagnosis

if [[ ! -z $missing_commands ]]; then
    _writeHeader "Diagnosis"
    _writeLogTerminal 2 "Some required commands are not available:"
    for command in "${missing_commands[@]}"; do
        echo $command
    done
    echo
    _writeMessage "You can proceed but some features of the ML4W Dotfiles will not work."
    _writeMessage "Please install the missing packages manually for your distribution."
    echo
    if gum confirm "Do you want to proceed?"; then
        echo
    elif [ $? -eq 130 ]; then
        _writeCancel
        exit 130
    else
        _writeCancel
        exit
    fi
else
    _writeLogTerminal 1 "Required commands checked"
fi
