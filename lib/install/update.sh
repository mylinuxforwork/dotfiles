#!/bin/bash
sleep 1

_runUpdate() {
    case $install_platform in
        arch)
            bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)
        ;;
        fedora)
            bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-fedora.sh)
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
}

_runUpdate
