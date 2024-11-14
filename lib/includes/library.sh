#!/bin/bash
#  _     _ _                           
# | |   (_) |__  _ __ __ _ _ __ _   _  
# | |   | | '_ \| '__/ _` | '__| | | | 
# | |___| | |_) | | | (_| | |  | |_| | 
# |_____|_|_.__/|_|  \__,_|_|   \__, | 
#                               |___/  
#  
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 

# ------------------------------------------------------
# Write dialog header
# ------------------------------------------------------

_writeHeader() {
    echo -e "${GREEN}"
    figlet -f smslant $1
    echo -e "${NONE}"
}

# ------------------------------------------------------
# Function: Is package installed
# ------------------------------------------------------

_isInstalled() {
    package="$1";
    case $install_platform in
        arch)
            check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
            if [ -n "${check}" ]; then
                echo 0
            else
                echo 1
            fi
        ;;
        fedora)
            check=$(dnf list --installed | grep $package)
            if [ -z "$check" ]; then
                echo 1
            else
                echo 0
            fi        
        ;;
        *)
            _writeLogTerminal 2 "Selected platform $install_platform is not supported"
            exit
        ;;
    esac    
}

# ------------------------------------------------------
# Function Install all package if not installed
# ------------------------------------------------------
_installPackage() {

    # Check if package is already installed
    if [[ $(_isInstalled "$1") == 0 ]]; then

        _writeLogTerminal 0 "$1 is already installed."
    else

        if [ -f "$packages_directory/$install_platform/special/$1" ]; then

            _writeLogTerminal 0 "Installing $1 with custom script..."

            # Source custom installation script for package
            source $packages_directory/$install_platform/special/$1
        else

            # Check if installation script exist and not empty
            _writeLogTerminal 0 "Installing $1..."

            # Run installation with platform command
            case $install_platform in
                arch)
                    sudo pacman --noconfirm -S "$1" &>> $(_getLogFile)
                ;;
                fedora)
                    sudo dnf install --assumeyes "$1" &>> $(_getLogFile)
                ;;
                *)
                    _writeLogTerminal 2 "Selected platform $install_platform is not supported"
                    exit
                ;;
            esac    

            # Check that installation was successful
            if [[ $(_isInstalled "$1") == 0 ]]; then
                _writeLogTerminal 1 "$1 installed successfully."
            else
                _writeLogTerminal 2 "$1 installation failed. Please install $1 manually."
            fi
        fi
    fi
}

_installPackages() {
    for pkg; do
        _installPackage "${pkg}"
    done
}

_removePackage() {
    _writeLogTerminal 0 "Removing $1..."
    case $install_platform in
        arch)
            sudo pacman --noconfirm -R "$1" &>> $(_getLogFile)
        ;;
        fedora)
            sudo dnf remove --assumeyes "$1" &>> $(_getLogFile)
        ;;
        *)
            _writeLogTerminal 2 "Selected platform $install_platform is not supported"
            exit
        ;;
    esac    
}

# ------------------------------------------------------
# Cleanup
# ------------------------------------------------------

_isFolderEmpty() {
    folder="$1"
    if [ -d $folder ] ;then
        if [ -z "$(ls -A $folder)" ]; then
            echo 0
        else
            echo 1
        fi
    else
        echo 1
    fi
}

_move_folder() {
    source=$1
    target=$2
    if [ ! -d $target ] ;then
        if [ -d $source ] ;then
            mv $source $target
            echo ":: $source moved to $target"
        fi
    fi    
}

_del_folder() {
    source=$1
    if [ -d $source ] ;then
        rm -rf $source
        echo ":: $source deleted"
    fi    
}

_move_file() {
    source=$1
    target=$2
    if [ ! -f $target ] ;then
        if [ -f $source ] ;then
            mv $source $target
            echo ":: $source moved to $target"
        fi
    fi    
}

_del_file() {
    source=$1
    if [ -f $source ] ;then
        rm $source
        echo ":: $source deleted"
    fi    
}

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
_del_symlink() {
    source=$1
    if [ -L $source ]; then
        rm $source
        echo ":: Symlink $sources deleted"
    elif [ -d $source ]; then
        rm -rf $source
        echo ":: Folder for symlink $sources deleted"
    elif [ -f $source ]; then
        rm -rf $source
        echo ":: File for symlink $sources deleted"
    fi
}

_installSymLink() {
    name="$1"
    symlink="$2";
    linksource="$3";
    linktarget="$4";
    
    if [ -L "${symlink}" ]; then
        rm ${symlink}
        ln -s ${linksource} ${linktarget} 
        echo ":: Symlink ${linksource} -> ${linktarget} created."
    else
        if [ -d ${symlink} ]; then
            rm -rf ${symlink}/ 
            ln -s ${linksource} ${linktarget}
            echo ":: Symlink for directory ${linksource} -> ${linktarget} created."
        else
            if [ -f ${symlink} ]; then
                rm ${symlink} 
                ln -s ${linksource} ${linktarget} 
                echo ":: Symlink to file ${linksource} -> ${linktarget} created."
            else
                ln -s ${linksource} ${linktarget} 
                echo ":: New symlink ${linksource} -> ${linktarget} created."
            fi
        fi
    fi
}

# ------------------------------------------------------
# Installation in a KVM Virtual Machine
# ------------------------------------------------------
_isKVM() {
    iskvm=$(sudo dmesg | grep "Hypervisor detected")
    if [[ "$iskvm" =~ "KVM" ]] ;then
        echo 0
    else
        echo 1
    fi
}

# _replaceInFile $startMarker $endMarker $customtext $targetFile
_replaceInFile() {

    # Set function parameters
    start_string=$1
    end_string=$2
    new_string="$3"
    file_path="$4"

    # Counters
    start_line_counter=0
    end_line_counter=0
    start_found=0
    end_found=0

    if [ -f $file_path ] ;then

        # Detect Start String
        while read -r line
        do
            ((start_line_counter++))
            if [[ $line = *$start_string* ]]; then
                # echo "Start found in $start_line_counter"
                start_found=$start_line_counter
                break
            fi 
        done < "$file_path"

        # Detect End String
        while read -r line
        do
            ((end_line_counter++))
            if [[ $line = *$end_string* ]]; then
                # echo "End found in $end_line_counter"
                end_found=$end_line_counter
                break
            fi 
        done < "$file_path"

        # Check that deliminters exists
        if [[ "$start_found" == "0" ]] ;then
            echo "ERROR: Start deliminter not found."
            sleep 2
        fi
        if [[ "$end_found" == "0" ]] ;then
            echo "ERROR: End deliminter not found."
            sleep 2
        fi

        # Replace text between delimiters
        if [[ ! "$start_found" == "0" ]] && [[ ! "$end_found" == "0" ]] && [ "$start_found" -le "$end_found" ] ;then
            # Remove the old line
            ((start_found++))

            if [ ! "$start_found" == "$end_found" ] ;then    
                ((end_found--))
                sed -i "$start_found,$end_found d" $file_path
            fi
            # Add the new line
            sed -i "$start_found i $new_string" $file_path
        else
            echo "ERROR: Delimiters syntax."
            sleep 2
        fi
    else
        echo "ERROR: Target file not found."
        sleep 2
    fi
}

# replaceTextInFile $customtext $targetFile
_replaceTextInFile() {
    # Set function parameters
    customtext="$1"
    targetFile=$2

    echo $customtext > $targetFile
}

# replaceLineInFile $findText $customtext $targetFile
_replaceLineInFile() {
   # Set function parameters
    find_string="$1"
    new_string="$2"
    file_path=$3

    # Counters
    find_line_counter=0
    line_found=0

    if [ -f $file_path ] ;then

        # Detect Line
        while read -r line
        do
            ((find_line_counter++))
            if [[ $line = *$find_string* ]]; then
                # echo "Start found in $start_line_counter"
                line_found=$find_line_counter
                break
            fi 
        done < "$file_path"

        if [[ ! "$line_found" == "0" ]] ;then
            
            #Remove the line
            sed -i "$line_found d" $file_path

            # Add the new line
            sed -i "$line_found i $new_string" $file_path            

        else
            echo "ERROR: Target line not found for $find_string."
            sleep 2
        fi   

    else
        echo "ERROR: Target file not found for $find_string."
        sleep 2
    fi
}

# replaceLineInFileCheckpoint $findText $customtext $checkpoint $targetFile
_replaceLineInFileCheckpoint() {
   # Set function parameters
    find_string="$1"
    new_string="$2"
    checkpoint="$3"
    file_path=$4

    # Counters
    find_checkpoint_counter=0
    find_line_counter=0
    line_found=0
    checkpoint_found=0

    if [ -f $file_path ] ;then

        # Detect Checkpoint
        while read -r line
        do
            ((find_checkpoint_counter++))
            if [[ $line = *$checkpoint* ]]; then
                # echo "Checkpoint found in $find_checkpoint_counter"
                checkpoint_found=$find_checkpoint_counter
                break
            fi 
        done < "$file_path"

        if [[ ! "$checkpoint_found" == "0" ]] ;then

            # Detect Line
            while read -r line
            do
                ((find_line_counter++))
                if [ "$find_line_counter" -gt "$checkpoint_found" ] ;then
                    if [[ $line = *$find_string* ]]; then
                        # echo "Line found in $find_line_counter"
                        line_found=$find_line_counter
                        break
                    fi 
                fi
            done < "$file_path"

            if [[ ! "$line_found" == "0" ]] ;then
                
                #Remove the line
                sed -i "$line_found d" $file_path

                # Add the new line
                sed -i "$line_found i $new_string" $file_path            

            else
                echo "ERROR: Target line not found for $find_string."
                sleep 2
            fi
        else 
            echo "ERROR: Checkpoint not found."
        fi  

    else
        echo "ERROR: Target file not found for $find_string."
        sleep 2
    fi
}

# ------------------------------------------------------
# System check
# ------------------------------------------------------

_checkCommandExists() {
    package="$1";
    if ! type $package > /dev/null 2>&1; then
        echo "1"
    else
        echo "0"
    fi
}

_commandExists() {
    package="$1";
    if [[ $(_checkCommandExists $package) == "1" ]]; then
        echo ":: ERROR: $package doesn't exists. Please install it manually."
    else
        echo ":: OK: $package command found."
    fi
}

_folderExists() {
    folder="$1";
    if [ ! -d $folder ]; then
        echo ":: ERROR: $folder doesn't exists. $2"
        return 0
    else
        echo ":: OK: $folder found."
        return 1
    fi
}
