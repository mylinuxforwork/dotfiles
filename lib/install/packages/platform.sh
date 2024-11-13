# ------------------------------------------------------
# Select platform
# ------------------------------------------------------
_writeLogHeader "Platform"

# Try to get the platform from existing installation
if [ -f .config/ml4w/settings/platform.sh ]; then
    install_platform=$(cat .config/ml4w/settings/platform.sh)
else
    # Select the platform if not defined with parameter
    if [ -z $install_platform ]; then
        _writeMessage "Please select your platform to install the ML4W Dotfiles."
        echo
        install_platform=$(gum choose "arch" "fedora" "CANCEL")
    fi
fi

# Check if platform is supported
case $install_platform in
    arch)
        _writeLogTerminal 0 "Installation on Arch based platform"
    ;;
    fedora)
        _writeLogTerminal 0 "Installation on Fedora based platform"
    ;;
    CANCEL)
        _writeCancel
        exit
    ;;
    *)
        _writeCancel
        exit
    ;;
esac
echo