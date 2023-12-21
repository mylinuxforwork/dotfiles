# ------------------------------------------------------
# Install pywal
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Pywal"
echo -e "${NONE}"
if [ -f /usr/bin/wal ]; then
    echo "pywal already installed. Trying to force the installation with python-pywal"
    yay -S --noconfirm python-pywal --ask 4
else
   yay -S --noconfirm python-pywal
    echo "Pywal installed."
fi
echo ""