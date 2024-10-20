# Check .config
if [ -d ~/$dot_folder/.config ]; then 
    echo -e "${GREEN}"
    figlet -f smslant "Protected"
    echo -e "${NONE}"
    echo ":: The script will check for file PROTECTED in subfolders of .config"
    echo ":: These folders and their files are not overwritten."
    echo 
    files=$(ls -a ~/$dot_folder/.config)
    for f in $files; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ]; then
            if [ -d  ~/$dot_folder/.config/$f ] ;then
                echo ":: Checking for directory ~/.config/$f"
                if [ -f $HOME/.config/$f/PROTECTED ]; then
                    if [ -d $ml4w_directory/$version/.config/$f ]; then
                        echo ":: Folder ~/.config/$f is protected"
                        rm -rf $ml4w_directory/$version/.config/$f/
                    fi
                fi
            fi
        fi
    done
fi