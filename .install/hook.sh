# ------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------
if [ -f ~/dotfiles-versions/hook.sh ]; then
cat <<"EOF"
 _   _             _    
| | | | ___   ___ | | __
| |_| |/ _ \ / _ \| |/ /
|  _  | (_) | (_) |   < 
|_| |_|\___/ \___/|_|\_\
                        
EOF
    echo "The script has detected a hook.sh script."
    if gum confirm "Do you want to run the script now?"; then
        source ~/dotfiles-versions/hook.sh
        echo "hook.sh executed!"
    fi
fi
