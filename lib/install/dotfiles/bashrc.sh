# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
_writeLogHeader ".bashrc"

if [ -f ~/.bashrc ] ;then
    if ! test -L ~/.bashrc ;then
        _writeHeader ".bashrc"

        _writeMessage "The script has detected an existing .bashrc file."
        _writeMessage "You can replace it with the latest version of ML4W Dotfiles $version (Recommended)."
        echo
        if [ -z $automation_bashrc ] ;then
            if gum confirm "Do you want to replace your existing .bashrc?" ;then
                rm ~/.bashrc
                _writeLogTerminal 0 ".bashrc will be installed"
            elif [ $? -eq 130 ]; then
                    exit 130
            else
                _writeSkipped
            fi
        else
            if [[ "$automation_bashrc" = true ]] ;then
                _writeLogTerminal 0 "AUTOMATION: .bashrc will be installed."
            elif [[ "$automation_bashrc" = false ]] ;then
                rm $ml4w_directory/$version/.bashrc
                _writeSkipped
            else
                _writeLogTerminal 2 "AUTOMATION ERROR: bashrc"
                exit
            fi
        fi
    fi
fi
echo 
