# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
cat <<"EOF"
   _               _              
  | |__   __ _ ___| |__  _ __ ___ 
  | '_ \ / _` / __| '_ \| '__/ __|
 _| |_) | (_| \__ \ | | | | | (__ 
(_)_.__/ \__,_|___/_| |_|_|  \___|
                                  
EOF

while true; do
    if [ -f ~/.bashrc ]; then
        echo "The script has detected an existing .bashrc file. "
    fi
    if [ -f ~/dotfiles-versions/backups/$datets/.bashrc-old ]; then
        echo "Backup is available here ~/dotfiles-versions/backups/$datets/.bashrc-old"
    fi
    if [ -f ~/.bashrc ]; then
        echo "Do you want to replace your existing .bashrc file with the dotfiles .bashrc file?"
    else
        echo "Do you want to install the dotfiles .bashrc file now?"
    fi
    read -p "Please confirm (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            _installSymLink .bashrc ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc
        break;;
        [Nn]* ) 
            echo "Installation skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""
