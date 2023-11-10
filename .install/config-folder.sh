# ------------------------------------------------------
# Create .config folder
# ------------------------------------------------------

if [ -d ~/.config ]; then
    echo ".config folder already exists."
else
    mkdir ~/.config
    echo ".config folder created."
fi
echo ""
