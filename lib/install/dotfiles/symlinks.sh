# ------------------------------------------------------
# Install dotfiles
# ------------------------------------------------------

echo ":: Creating symlinks"
# Check home
files=$(ls -a ~/"$dot_folder")
for f in $files; do
    if [ ! "$f" == "." ] && [ ! "$f" == ".." ] && [ ! "$f" == ".config" ]; then
        if [ -f ~/"$dot_folder"/"$f" ]; then
            echo ":: Checking for file ~/$f"
            if [ -L ~/"$f" ]; then
                rm ~/"$f"
            fi
            if [ -f ~/"$f" ]; then
                rm ~/"$f"
            fi
        fi
    fi
done

# Check .config
files=$(ls -a ~/"$dot_folder"/.config)
for f in $files; do
    if [ ! "$f" == "." ] && [ ! "$f" == ".." ]; then
        if [ -d ~/"$dot_folder"/.config/"$f" ]; then
            echo ":: Checking for directory ~/.config/$f"
            if [ -L ~/.config/"$f" ]; then
                rm ~/.config/"$f"
            fi
            if [ -f ~/.config/"$f" ]; then
                rm ~/.config/"$f"
            fi
            if [ -d ~/.config/"$f" ]; then
                rm -rf ~/.config/"$f"
            fi
        fi
        if [ -f ~/"$dot_folder"/.config/"$f" ]; then
            echo ":: Checking for file ~/.config/$f"
            if [ -L ~/.config/"$f" ]; then
                rm ~/.config/"$f"
            fi
            if [ -f ~/.config/"$f" ]; then
                rm ~/.config/"$f"
            fi
        fi
    fi
done

stow --dir="$HOME/$dot_folder" --target="$HOME" .

echo ":: Symbolic links created."
echo
