# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
   _               _              
  | |__   __ _ ___| |__  _ __ ___ 
  | '_ \ / _` / __| '_ \| '__/ __|
 _| |_) | (_| \__ \ | | | | | (__ 
(_)_.__/ \__,_|___/_| |_|_|  \___|
EOF
echo -e "${NONE}"
if [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
    echo "PLEASE NOTE AGAIN: The script has detected an existing .bashrc file."
fi
if [ -f ~/dotfiles-versions/backups/$datets/.bashrc-old ]; then
    echo "Backup is already available here ~/dotfiles-versions/backups/$datets/.bashrc-old"
fi
if [ ! -L ~/.bashrc ] && [ -f ~/.bashrc ]; then
    bash_confirm="Do you want to replace your existing .bashrc file with the dotfiles .bashrc file?"
else
    bash_confirm="Do you want to install the dotfiles .bashrc file now?"
fi
if gum confirm "$bash_confirm" ;then
    _installSymLink .bashrc ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc
elif [ $? -eq 130 ]; then
        exit 130
else
    echo "Installation of the .bashrc file skipped."
fi
echo ""
