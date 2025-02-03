# ------------------------------------------------------
# Install dotfiles
# ------------------------------------------------------
_writeLogHeader "Symlinks"

# Check home
files=$(ls -a $HOME/$dot_folder)
for f in $files; do
    if [ ! "$f" == "." ] && [ ! "$f" == ".." ] && [ ! "$f" == ".config" ]; then
        if [ -f  $HOME/$dot_folder/$f ]; then
            # echo ":: Checking for file $HOME/$f"
            if [ -L $HOME/$f ]; then
                rm $HOME/$f
            fi
            if [ -f ~/$f ]; then
                rm $HOME/$f
            fi
            ln -s $HOME/$dot_folder/$f $HOME
            if [ -L $HOME/$f ]; then
                _writeLog 1 "$HOME/$dot_folder/$f -> $HOME/$f"
            else
                _writeLog 2 "$HOME/$dot_folder/$f -> $HOME/$f"
            fi
        fi
    fi
done

# Check .config
files=$(ls -a $HOME/$dot_folder/.config)
for f in $files; do
    if [ ! "$f" == "." ] && [ ! "$f" == ".." ]; then
        if [ -d  $HOME/$dot_folder/.config/$f ]; then
            # echo ":: Checking for directory $HOME/.config/$f"
            if [ -L $HOME/.config/$f ]; then
                rm $HOME/.config/$f
            fi
            if [ -f $HOME/.config/$f ]; then
                rm $HOME/.config/$f
            fi
            if [ -d $HOME/.config/$f ]; then
                rm -rf $HOME/.config/$f
            fi
            ln -s $HOME/$dot_folder/.config/$f $HOME/.config
            if [ -L $HOME/.config/$f ]; then
                _writeLog 1 "$HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
            else
                _writeLog 2 "$HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
            fi
        fi
        if [ -f  $HOME/$dot_folder/.config/$f ]; then
            # echo ":: Checking for file $HOME/.config/$f"
            if [ -L $HOME/.config/$f ]; then
                rm $HOME/.config/$f
            fi
            if [ -f $HOME/.config/$f ]; then
                rm $HOME/.config/$f
            fi
            ln -s $HOME/$dot_folder/.config/$f $HOME/.config
            if [ -L $HOME/.config/$f ]; then
                _writeLog 1 "$HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
            else
                _writeLog 2 "$HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
            fi
        fi
    fi
done