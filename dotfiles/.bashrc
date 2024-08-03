#    _               _              
#   | |__   __ _ ___| |__  _ __ ___ 
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__ 
# (_)_.__/ \__,_|___/_| |_|_|  \___|
# 
# by Stephan Raabe (2024)
# -----------------------------------------------------
# ~/.bashrc
# -----------------------------------------------------
# You can add your custom configuration by creating a file ~/.bashrc_custom

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# Define Editor
export EDITOR=nvim

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vim='$EDITOR'
alias ts='~/.config/ml4w/scripts/snapshot.sh'
alias wifi='nmtui'
alias cleanup='~/.config/ml4w/scripts/cleanup.sh'

# -----------------------------------------------------
# ML4W Apps
# -----------------------------------------------------
alias ml4w='~/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage'
alias ml4w-settings='~/.config/ml4w/apps/ML4W_Dotfiles_Settings-x86_64.AppImage'
alias ml4w-sidebar='ags -t sidebar'
alias ml4w-hyprland='~/.config/ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage'
alias ml4w-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-hyprland-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-qtile-diagnosis='~/.config/ml4w/qtile/scripts/diagnosis.sh'
alias ml4w-update='~/.config/ml4w/update.sh'

# -----------------------------------------------------
# Window Managers
# -----------------------------------------------------

alias Qtile='startx'
# Hyprland with Hyprland

# -----------------------------------------------------
# GIT
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# SCRIPTS
# -----------------------------------------------------
alias ascii='~/.config/ml4w/scripts/figlet.sh'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# QTILE
# -----------------------------------------------------
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap de;echo "Keyboard set back to de."'

export PATH="/usr/lib/ccache/bin/:$PATH"

# -----------------------------------------------------
# LOAD CUSTOM .bashrc_custom
# -----------------------------------------------------
if [ -f ~/.bashrc_custom ] ;then
    source ~/.bashrc_custom
fi

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
eval "$(starship init bash)"

# -----------------------------------------------------
# PYWAL
# -----------------------------------------------------
cat ~/.cache/wal/sequences

# -----------------------------------------------------
# Fastfetch if on wm
# -----------------------------------------------------
if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config examples/13
else
    echo
    if [ -f /bin/qtile ]; then
        echo "Start Qtile X11 with command Qtile"
    fi
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi
