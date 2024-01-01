# Settings Library

# Load module
_getModules() {
    clear

    # Get path to parent folder to go back
    back="$(dirname "$1")"

    # Load module config
    if [ -f $1/init.sh ]; then
        source $1/init.sh
    fi

    # Load module config
    if [ -f $1/config.sh ]; then
        source $1/config.sh
    else
        echo "ERROR: config.sh doesn't exists in $1"
        exit
    fi

    clickArr+=("/")
    clickArr+=("$name")
    echo "You are here:" ${clickArr[@]}

    # Load module
    if [ -f $1/module.sh ]; then
        source $1/module.sh
    else
        echo "ERROR: module.sh doesn't exists in $1"
        # exit 0
    fi

    # Read folder
    modules=$(find $1 -maxdepth 1 -type d)
    count=0

    # Check if subfolders exists
    for value in $modules
    do
        if [[ ! "$value" == "$1" ]]; then
            # Check if custom version of module exists and skip original module
            if [ ! -d "$value-custom" ]; then 
                ((count++))
            fi
        fi
    done

    # Create Navigation
    unset modulesArr
    if [[ ! $count == 0 ]]; then

        # Get modules folders
        for value in $modules
        do
            if [[ ! "$value" == "$1" ]]; then
                if [[ ! $value == *"-custom" ]]; then
                    if [ ! -d "$value-custom" ]; then 
                        if [ -f $value/config.sh ]; then
                            source $value/config.sh
                            modulesArr+=("$order:$name:$value")
                        else
                            echo "ERROR: config.sh doesn't exists in $value"
                            exit
                        fi
                    else
                        if [ -f $value-custom/config.sh ]; then
                            source $value-custom/config.sh
                            modulesArr+=("$order:$name:$value-custom")
                        else
                            echo "ERROR: config.sh doesn't exists in $value-custom"
                            exit
                        fi
                    fi
                fi
            fi
        done
        # Sort array by order
        IFS=$'\n' modulesArr=($(sort <<<"${modulesArr[*]}"))
        unset nameList
        unset pathList

        # Output
        for value in "${modulesArr[@]}"
        do
            name="$(cut -d':' -f2 <<<"$value")"
            path="$(cut -d':' -f3 <<<"$value")"
            nameList+=("$name")
            pathList+=("$path")
        done
        if [[ "$back" == "$installFolder/settings" ]]; then
            nameList+=("EXIT")
        else
            nameList+=("BACK")
        fi
        echo ""
        selected=$(gum choose ${nameList[@]})
        case $selected in
            BACK)
                _goBack
            break;;
            EXIT)
                clear
                exit
            break;;            
            * ) 

            ;;
        esac
        if [ ! -z $selected ] ;then
            for i in "${!nameList[@]}"; do
                if [[ "${nameList[$i]}" = "${selected}" ]]; then
                    nameIndex="${i}"
                fi
            done
            current="${pathList[$nameIndex]}"
            _getModules "$current"
        else
            if [[ "$back" == "$installFolder/settings" ]]; then
                clear
                exit
            else
                _goBack
            fi            
        fi
    fi
}

# _getConfSelector conf/monitor.conf conf/monitors/
_getConfSelector() {
    cur=$(cat $installFolder/conf/$1)
    echo "Folder: $installFolder/conf/$2"
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    echo ""
    sel=$(gum choose $(ls $installFolder/conf/$2))

    if [ -z $sel ] ;then
        _goBack
    fi
    echo "File $sel selected."
    echo ""
}

_getConfEditor() {
    selected=$(gum choose "EXECUTE" "EDIT" "COPY" "DELETE" "CANCEL")
    case $selected in
        EXECUTE)
            _writeConf $1 $2 $3
        break;;            
        EDIT)
            vim $installFolder/conf/$3/$2
            sleep 1
            _reloadModule
        break;;            
        COPY)
            echo "Define the new file name. Please use [a-zA-Z1-9_-]+.conf"
            filename=$(gum input --value="custom-${sel##*/}" --placeholder "Enter your filename")
            if [ -z $filename ] ;then
                echo "ERROR: No filename specified."
            else
                if ! [[ $filename =~ ^[a-zA-Z1-9_-]+.conf ]]; then
                    echo "ERROR: Wrong filename format. Please use [a-zA-Z1-9_-]+.conf"
                else
                    if [ -f $(dirname $sel)/$filename ] ;then
                        echo "ERROR: File already exists."
                    else
                        cp $installFolder/conf/$3/$sel $installFolder/conf/$3/$filename
                        _reloadModule
                    fi
                fi
            fi
            _getConfEditor $1 $2 $3
        break;;            
        DELETE)
            if gum confirm "Do you really want to delete the file $sel?" ;then
                rm $installFolder/conf/$3/$sel
                _reloadModule
            else
                _getConfEditor $1 $2 $3
            fi
        break;;
        * ) 
        ;;
    esac    
}

# _writeConf conf/monitor.conf $sel
_writeConf() {
    if [ ! -z $2 ] ;then
        editsel=$(echo "$installFolder/conf/$3/$2" | sed "s+"\/home\/$USER"+~+")
        echo "source = $editsel" > $installFolder/conf/$1
    fi
}

# _replaceInFile $startMarket $endMarker $customtext $targetFile
_replaceInFile() {

    # Set function parameters
    start_string=$1
    end_string=$2
    new_string="$3"
    file_path=$4

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

# _writeSettings $settingsFile $customtext
_writeSettings() {
    if [ ! -f $1 ] ;then
        touch $1
    fi
    echo "$2" > $1
}

# Return the version of the hyprland-settings script
_getVersion() {
    echo $version
}

# Write the header to a page
_getHeader() {
    figlet -w 100 "$1"
    if [ ! -z "$2" ]; then
        echo "by $2"
    fi
    echo ""
}

# Update the breadcrumb and opens parent page
_goBack() {
    unset clickArr[-1]
    unset clickArr[-1]
    unset clickArr[-1]
    unset clickArr[-1]
    _getModules "$back"
}

_reloadModule() {
    unset clickArr[-1]
    unset clickArr[-1]
    _getModules "$current"
}

# Replace the variables in a template and publish to location
_replaceByTemplate() {
    template=$1
    variables=$2
    values=$3
    publishto=$4
}

# Back Button
_getBackBtn() {
    echo ""
    gum choose "Back"
    _goBack
}

_getBackRepeatBtn() {
        echo ""
        selected=$(gum choose "REPEAT" "BACK")
        case $selected in
            BACK)
                _goBack
            break;;
            REPEAT)
                _getModules "$current"
            break;;            
            * ) 

            ;;
        esac    
}
