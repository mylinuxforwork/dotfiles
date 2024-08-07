if [ -f ~/.cache/ml4w-post-install ] ;then
    terminal=$(cat ~/.config/ml4w/settings/terminal.sh)
    $terminal -e ~/.config/ml4w/postinstall.sh
    rm ~/.cache/ml4w-post-install
    $HOME/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage
else
    echo ":: Post installation script already executed"
    exit
fi
