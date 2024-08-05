# Search for the line containing "ParallelDownloads = 5"
line=$(grep "ParallelDownloads = 5" /etc/pacman.conf)

# Check if the line starts with a '#' character
if [[ $line == \#* ]]; then
    echo -e "${GREEN}"
    figlet "Downloads"
    echo -e "${NONE}"
    echo ":: AUTOMATION: Activate parallel downloads"
    new_line=$(echo $line | sed 's/^#//')
    sudo sed -i "s/$line/$new_line/g" /etc/pacman.conf
fi

# Activate Color in pacman.conf
if grep -Fxq "#Color" /etc/pacman.conf
then
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
fi
if grep -Fxq "# Color" /etc/pacman.conf
then
    sudo sed -i 's/^# Color/Color/' /etc/pacman.conf
fi
echo