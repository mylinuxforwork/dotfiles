# ------------------------------------------------------
# Install .zshrc
# ------------------------------------------------------

if [ -f $HOME/.zshrc ]; then
    if [ -z $automation_zshrc ]; then
        _writeHeader ".zshrc"
        _writeMessage "The script has detected an existing .zshrc file."
        _writeMessage "You can keep it or replace it with the latest version of ML4W Dotfiles $version"
        echo
        if gum confirm "Do you want to KEEP your existing .zshrc?" --affirmative "KEEP" --negative "REPLACE" ;then
            rm $ml4w_directory/$version/.zshrc
            rm -rf $ml4w_directory/$version/.config/zshrc
            _writeSkipped
        elif [ $? -eq 130 ]; then
                exit 130
        else
            rm ~/.zshrc
            _writeLogTerminal 0 ".zshrc will be installed"
        fi
    else
        if [[ "$automation_zshrc" = true ]]; then
            _writeLogTerminal 0 "AUTOMATION: .zshrc will be installed."
        elif [[ "$automation_zshrc" = false ]]; then
            rm $ml4w_directory/$version/.zshrc
            rm -rf $ml4w_directory/$version/.config/zshrc
            _writeSkipped
        else
            _writeLogTerminal 2 "AUTOMATION ERROR: zshrc"
            exit
        fi
    fi
fi
echo
