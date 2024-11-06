# ------------------------------------------------------
# Install .zshrc
# ------------------------------------------------------
_writeLogHeader ".zshrc"

_zshrc_confirm() {
    if gum confirm "Do you want to replace your existing .zshrc?" ;then
        rm ~/.zshrc
        echo ":: .zshrc will be installed"
    elif [ $? -eq 130 ]; then
            exit 130
    else
        echo ":: Installation of the .zshrc file skipped."
    fi
}

_zsh_automation() {
    if [[ "$automation_zshrc" = true ]] ;then
        echo ":: AUTOMATION: .zshrc will be installed."
    elif [[ "$automation_zshrc" = false ]] ;then
        rm $ml4w_directory/$version/.zshrc
        echo ":: AUTOMATION: Installation of the .zshrc file skipped."
    else
        echo ":: AUTOMATION ERROR: zshrc"
        exit
    fi
}

if [ -f ~/.zshrc ] ;then
    if ! test -L ~/.zshrc ;then
        _writeHeader ".zshrc"
        echo ":: The script has detected an existing .zshrc file."
        echo ":: You can replace it with the latest version of ML4W Dotfiles $version (Recommended)."
        echo
        if [ -z $automation_zshrc ] ;then
            _zshrc_confirm
        else
            _zsh_automation
        fi
    fi
fi
echo
