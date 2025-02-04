# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

if [ -f $HOME/.bashrc ]; then
    if [ -z $automation_bashrc ]; then
        _writeHeader ".bashrc"
        _writeMessage "The script has detected an existing .bashrc file."
        _writeMessage "You can keep it or replace it with the latest version of ML4W Dotfiles $version"
        echo
        if gum confirm "Do you want to KEEP your existing .bashrc?" --affirmative "KEEP" --negative "REPLACE" ;then
            rm $ml4w_directory/$version/.bashrc
            rm -rf $ml4w_directory/$version/.config/bashrc
            _writeSkipped
        elif [ $? -eq 130 ]; then
                exit 130
        else
            rm ~/.bashrc
            _writeLogTerminal 0 ".bashrc will be installed"
        fi
    else
        if [[ "$automation_bashrc" = true ]]; then
            _writeLogTerminal 0 "AUTOMATION: .bashrc will be installed."
        elif [[ "$automation_bashrc" = false ]]; then
            rm $ml4w_directory/$version/.bashrc
            rm -rf $ml4w_directory/$version/.config/bashrc
            _writeSkipped
        else
            _writeLogTerminal 2 "AUTOMATION ERROR: bashrc"
            exit
        fi
    fi
fi
echo
