# ------------------------------------------------------
# Select platform
# ------------------------------------------------------
_writeLogHeader "Platform"

# Select the platform if not defined with parameter
if [ -z $install_platform ]; then
    _writeMessage "Please select your platform to install the ML4W Dotfiles."
    echo
    install_platform=$(gum choose "arch" "fedora")
fi

# Check if platform is supported
case $install_platform in
    arch)
        _writeLogTerminal 0 "Installation on Arch based platform"
    ;;
    fedora)
        _writeLogTerminal 0 "Installation on Fedora based platform"
    ;;
    *)
        _writeLogTerminal 2 "Selected platform $install_platform is not supported"
        exit
    ;;
esac
echo