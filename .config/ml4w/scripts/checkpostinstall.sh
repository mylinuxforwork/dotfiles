if [ -f ~/.cache/ml4w-post-install ] ;then
    terminal=$(cat ~/.config/ml4w/settings/terminal.sh)
    $terminal -e ~/.config/ml4w/postinstall.sh
    rm ~/.cache/ml4w-post-install
    com.ml4w.welcome
else
    echo ":: Post installation script already executed"
    exit
fi
