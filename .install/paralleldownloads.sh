#!/bin/bash
# ------------------------------------------------------
# Activate parallel downloads
# ------------------------------------------------------
# Search for the line containing "ParallelDownloads = 5"
line=$(grep "ParallelDownloads = 5" /etc/pacman.conf)

# Check if the line starts with a '#' character
if [[ $line == \#* ]]; then
    echo -e "${GREEN}"
    figlet "Downloads"
    echo -e "${NONE}"
    echo ":: You can activate 5 parallel downloads in pacman.conf to speedup the download of the packages?"
    if gum confirm "Do you want to activate parallel downloads?"; then

        # Remove the '#' character from the beginning of the line
        echo ":: Modifying pacman.conf to enable parallel downloads."
        new_line=$(echo $line | sed 's/^#//')

        # Replace the original line with the new line in the configuration file
        sudo sed -i "s/$line/$new_line/g" /etc/pacman.conf

        # Display a message indicating that the line was modified
        echo ":: Modified line: $new_line"
    elif [ $? -eq 130 ]; then
            exit
    else
        echo ":: Activation of parallel downloads skipped."
    fi
else
    # Check if the line is already uncommented
    if [[ $line == ParallelDownloads\ =\ 5 ]]; then
        # Display a message indicating that the line does not need to be modified
        echo ":: pacman.conf already optimized for parallel downloads."
    else
        # Display a message indicating that the line is missing or commented out
        echo ":: Parallel downloads could not be activated. Required configuration in /etc/pacman.conf could not found."
    fi
fi
echo