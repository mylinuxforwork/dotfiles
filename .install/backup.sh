# ------------------------------------------------------
# Backup existing dotfiles
# ------------------------------------------------------

datets=$(date '+%Y%m%d%H%M%S')

# Create Backup File Structure

if [ ! -d ~/dotfiles-versions ]; then
    mkdir ~/dotfiles-versions
    echo "~/dotfiles-versions created."
fi
if [ ! -d ~/dotfiles-versions/backup ]; then
    mkdir ~/dotfiles-versions/backup
    echo "~/dotfiles-versions/backup created"
fi
if [ -d ~/dotfiles-versions/backups ]; then
    mv ~/dotfiles-versions/backups ~/dotfiles-versions/archive
    echo ":: Existing backups moved into ~/dotfiles-versions/archive"
fi
if [ ! -d ~/dotfiles-versions/archive ]; then
    mkdir ~/dotfiles-versions/archive
    echo "~/dotfiles-versions/archive created"
fi

# Backup Existing Dotfiles

if [ -d ~/dotfiles ] || ! test -L ~/.bashrc || [ -d ~/.config/hypr ] || [ -d ~/.config/qtile ]; then

    echo -e "${GREEN}"
    figlet "Backup"
    echo -e "${NONE}"
    echo "The script has detected the following files and folders for a backup:"

    if [ -d ~/dotfiles ]; then
        echo "   - $HOME/dotfiles"
    fi
    if ! test -L ~/.bashrc ;then
        echo "   - $HOME/.bashrc"
    fi
    if ! test -L ~/.config/qtile && [ -d ~/.config/qtile ] ;then
        echo "   - $HOME/.config/qtile/"
    fi
    if ! test -L ~/.config/hypr && [ -d ~/.config/hypr ] ;then
        echo "   - $HOME/.config/hypr/"
    fi
    if ! test -L ~/.config/rofi && [ -d ~/.config/rofi ] ;then
        echo "   - $HOME/.config/rofi/"
    fi
    if ! test -L ~/.config/wal && [ -d ~/.config/wal ] ;then
        echo "   - $HOME/.config/wal/"
    fi
    if ! test -L ~/.config/waybar && [ -d ~/.config/waybar ] ;then
        echo "   - $HOME/.config/waybar/"
    fi
    if ! test -L ~/.config/wlogout && [ -d ~/.config/wlogout ] ;then
        echo "   - $HOME/.config/wlogout/"
    fi
    if ! test -L ~/.config/alacritty && [ -d ~/.config/alacritty ] ;then
        echo "   - $HOME/.config/alacritty/"
    fi
    if ! test -L ~/.config/starship && [ -d ~/.config/starship ] ;then
        echo "   - $HOME/.config/starship/"
    fi
    if ! test -L ~/.config/picom && [ -d ~/.config/picom ] ;then
        echo "   - $HOME/.config/picom/"
    fi
    if ! test -L ~/.config/nvim && [ -d ~/.config/nvim ] ;then
        echo "   - $HOME/.config/nvim/"
    fi
    if ! test -L ~/.config/vim && [ -d ~/.config/vim ] ;then
        echo "   - $HOME/.config/vim/"
    fi
    if ! test -L ~/.config/dunst && [ -d ~/.config/dunst ] ;then
        echo "   - $HOME/.config/dunst/"
    fi
    if ! test -L ~/.config/swappy && [ -d ~/.config/swappy ] ;then
        echo "   - $HOME/.config/swappy/"
    fi

    # Start Backup

    if gum confirm "Do you want to create a backup?" ;then

        if [ ! -z "$(ls -A ~/dotfiles-versions/backup)" ] ;then
            if gum confirm "Do you want to archive the existing backup?" ;then
                rsync -a ~/dotfiles-versions/backup/ ~/dotfiles-versions/archive/$datets/
                echo ":: Current backup archived in ~/dotfiles-versions/archive/$datets"
            fi
        fi
        if [ -d ~/dotfiles ]; then
            rsync -a ~/dotfiles ~/dotfiles-versions/backup/
            echo ":: Backup of $HOME/dotfiles created in ~/dotfiles-versions/backup"
        fi
        if ! test -L ~/.bashrc ;then
            cp ~/.bashrc ~/dotfiles-versions/backup
            echo ":: Backup of $HOME/.bashrc created in ~/dotfiles-versions/backup"
        fi
        if [ ! -d ~/dotfiles-versions/backup/config ] ;then
            mkdir ~/dotfiles-versions/backup/config
        fi
        if ! test -L ~/.config/qtile && [ -d ~/.config/qtile ] ;then
            cp -r ~/.config/qtile ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/qtile created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/hypr && [ -d ~/.config/hypr ] ;then
            cp -r ~/.config/hypr ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/hypr created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/qtile && [ -d ~/.config/rofi ] ;then
            cp -r ~/.config/rofi ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/rofi created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/wal && [ -d ~/.config/wal ] ;then
            cp -r ~/.config/wal ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/wal created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/waybar && [ -d ~/.config/waybar ] ;then
            cp -r ~/.config/waybar ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/waybar created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/wlogout && [ -d ~/.config/wlogout ] ;then
            cp -r ~/.config/wlogout ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/wlogout created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/alacritty && [ -d ~/.config/alacritty ] ;then
            cp -r ~/.config/alacritty ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/alacritty created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/starship && [ -d ~/.config/starship ] ;then
            cp -r ~/.config/starship ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/starship created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/picom && [ -d ~/.config/picom ] ;then
            cp -r ~/.config/picom ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/picom created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/nvim && [ -d ~/.config/nvim ] ;then
            cp -r ~/.config/nvim ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/nvim created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/vim && [ -d ~/.config/vim ] ;then
            cp -r ~/.config/vim ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/vim created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/dunst && [ -d ~/.config/dunst ] ;then
            cp -r ~/.config/dunst ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/dunst created in ~/dotfiles-versions/backup/config/"
        fi
        if ! test -L ~/.config/swappy && [ -d ~/.config/swappy ] ;then
            cp -r ~/.config/swappy ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/swappy created in ~/dotfiles-versions/backup/config/"
        fi        
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo ":: Backup skipped."
    fi
else
    echo ":: Nothing to backup"
fi
echo