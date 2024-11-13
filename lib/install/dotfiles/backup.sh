# ------------------------------------------------------
# Backup existing dotfiles
# ------------------------------------------------------
_writeLogHeader "Backup"

datets=$(date '+%Y%m%d%H%M%S')
files=$(ls -a $HOME/$dot_folder)
folders=$(ls -a $HOME/$dot_folder/.config)

# Write folder to backup
_write_backup_folder() {
    if ! test -L $HOME/.config/$1 && [ -d $HOME/.config/$1 ] ;then
        cp -r $HOME/.config/$1 $backup_directory/config
        _writeLogTerminal 1 "Backup of $HOME/.config/$1 created in $backup_directory/config/"
    fi
}

# Write file to backup
_write_backup_file() {
    if ! test -L $HOME/$1 ;then
        cp $HOME/.zshrc $backup_directory
        _writeLogTerminal 1 "Backup of $HOME/$1 created in $backup_directory"
    fi    
}

_create_backup() {
    # Archive existing backup
    if [ ! -z "$(ls -A $backup_directory)" ] ;then
        rsync -a $backup_directory/ $archive_directory/$datets/
        _writeLogTerminal 1 "Current backup archived in $archive_directory/$datets"
    fi

    # Backup dotfiles folder
    if [ -d ~/$dot_folder ]; then
        rsync -a ~/$dot_folder $backup_directory/
        _writeLog 1 "Backup of $HOME/$dot_folder created in $backup_directory"
    fi

    # Backup files
    for f in $files; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ] && [ ! "$f" == ".config" ]; then
            _write_backup_file $f
        fi
    done

    # Backup folder
    for f in $folders; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ]; then
            _write_backup_folder $f
        fi
    done
    _writeLogTerminal 1 "Backup created in $backup_directory"
}

# Create Backup File Structure
_createBackupStructure() {
    if [ ! -d $ml4w_directory ] ;then
        mkdir $ml4w_directory
        _writeLog 1 "$ml4w_directory folder created."
    fi
    if [ ! -d $backup_directory ]; then
        mkdir $backup_directory
        _writeLog 1 "$backup_directory created"
    fi
    if [ ! -d $archive_directory ]; then
        mkdir $archive_directory
        _writeLog 1 "$archive_directory created"
    fi
    if [ ! -d $backup_directory/config ] ;then
        mkdir $backup_directory/config
    fi
}

# Show files for a backup
_showBackup() {
    _writeMessage "The script has detected the following files and folders for a backup:"

    if [ -d ~/$dot_folder ]; then
        _writeMessage "$HOME/$dot_folder"
    fi

    for f in $files; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ] && [ ! "$f" == ".config" ]; then
            if ! test -L $HOME/$f ;then
                _writeMessage "$HOME/$f"
            fi
        fi
    done
    for f in $folders; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ]; then
            if ! test -L $HOME/.config/$f ;then
                _writeMessage "$HOME/.config/$f/"
            fi
        fi
    done
    echo 

    # Start Backup
    if [ -z $automation_backup ] ;then
        if gum confirm "Do you want to create a backup?" ;then
            _create_backup
        elif [ $? -eq 130 ]; then
            exit 130
        else
            _writeSkipped
        fi
    else
        if [[ "$automation_backup" = true ]] ;then
            _create_backup
        fi
    fi
}

_createBackupStructure
_writeHeader "Backup"
_showBackup