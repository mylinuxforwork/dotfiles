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

if [ -d ~/$dot_folder ] || ! test -L ~/.bashrc || [ -d ~/.config/hypr ] || [ -d ~/.config/qtile ]; then

    if [[ "$automation_backup" = true ]] ;then
        echo ":: AUTOMATION: Backup started"
        echo
        if [ ! -z "$(ls -A ~/dotfiles-versions/backup)" ] ;then
            rsync -a ~/dotfiles-versions/backup/ ~/dotfiles-versions/archive/$datets/
            echo ":: Current backup archived in ~/dotfiles-versions/archive/$datets"
        fi
        if [ -d ~/$dot_folder ]; then
            rsync -a ~/$dot_folder ~/dotfiles-versions/backup/
            echo ":: Backup of $HOME/$dot_folder created in ~/dotfiles-versions/backup"
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
        if ! test -L ~/.config/ml4w-hyprland-settings && [ -d ~/.config/ml4w-hyprland-settings ] ;then
            cp -r ~/.config/ml4w-hyprland-settings ~/dotfiles-versions/backup/config
            echo ":: Backup of $HOME/.config/ml4w-hyprland-settings created in ~/dotfiles-versions/backup/config/"
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
    elif [[ "$automation_backup" = false ]] ;then
        echo ":: AUTOMATION: Backup skipped."
    else
        echo ":: AUTOMATION ERROR: Backup"
    fi
else
    echo ":: AUTOMATION: Nothing to backup"
fi
echo