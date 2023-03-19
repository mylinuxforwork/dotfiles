#!/bin/bash
#  _____ _       _      _   
# |  ___(_) __ _| | ___| |_ 
# | |_  | |/ _` | |/ _ \ __|
# |  _| | | (_| | |  __/ |_ 
# |_|   |_|\__, |_|\___|\__|
#          |___/            
#
# by Stephan Raabe (2023)
# -----------------------------------------------------
# Script to create ascii font based header on user input
# and copy the result to the clipboard
# -----------------------------------------------------

read -p "Enter the text for ascii encoding: " mytext
figlet "$mytext" > ~/figlet.txt
echo "" >> ~/figlet.txt
echo "by Stephan Raabe (2023)" >> ~/figlet.txt
echo "-----------------------------------------------------" >> ~/figlet.txt
sed -i 's/^/# /; s/$/ /' ~/figlet.txt

xclip -sel clip ~/figlet.txt

echo "Text copied to clipboard!"
