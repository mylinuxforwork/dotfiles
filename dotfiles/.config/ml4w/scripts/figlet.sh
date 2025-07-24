#!/bin/bash
figlet -f smslant "Figlet"
echo
# ------------------------------------------------
# Script to create ascii font based header on user input
# and copy the result to the clipboard
# -----------------------------------------------------

read -p "Enter the text for ascii encoding: " mytext

if [ -f ~/figlet.txt ]; then
    touch ~/figlet.txt
fi

echo "cat <<\"EOF\"" >~/figlet.txt
figlet -f smslant "$mytext" >>~/figlet.txt
echo "" >>~/figlet.txt
echo "EOF" >>~/figlet.txt

lines=$(cat ~/figlet.txt)
wl-copy "$lines"
xclip -sel clip ~/figlet.txt

echo "Text copied to clipboard!"
