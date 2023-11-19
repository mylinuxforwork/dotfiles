# ------------------------------------------------------
# Install pywal
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
                           _ 
 _ __  _   ___      ____ _| |
| '_ \| | | \ \ /\ / / _` | |
| |_) | |_| |\ V  V / (_| | |
| .__/ \__, | \_/\_/ \__,_|_|
|_|    |___/                 

EOF
echo -e "${NONE}"
if [ -f /usr/bin/wal ]; then
    echo "pywal already installed. Trying to force the installation with python-pywal"
    yay -S --noconfirm python-pywal --ask 4
else
   yay -S --noconfirm python-pywal
    echo "Pywal installed."
fi
echo ""