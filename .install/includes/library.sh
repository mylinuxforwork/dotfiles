#!/bin/bash
#  _     _ _                           
# | |   (_) |__  _ __ __ _ _ __ _   _  
# | |   | | '_ \| '__/ _` | '__| | | | 
# | |___| | |_) | | | (_| | |  | |_| | 
# |_____|_|_.__/|_|  \__,_|_|   \__, | 
#                               |___/  
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ------------------------------------------------------
# Function: Is package installed
# ------------------------------------------------------
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_isInstalledYay() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "\." | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

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

# ------------------------------------------------------
# Function Install all package if not installed
# ------------------------------------------------------
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    # printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

_forcePackagesPacman() {
    toInstall=();
    for pkg; do
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    # printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}" --ask 4;
}

_installPackagesYay() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    yay --noconfirm -S "${toInstall[@]}";
}

_forcePackagesYay() {
    toInstall=();
    for pkg; do
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    yay --noconfirm -S "${toInstall[@]}" --ask 4;
}

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
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

# _replaceInFile $startMarket $endMarker $customtext $targetFile
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
            echo "ERROR: Target line not found."
            sleep 2
        fi   

    else
        echo "ERROR: Target file not found."
        sleep 2
    fi
}