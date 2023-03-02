#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# ALIASES
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias c='clear'
alias w='~/dotfiles/scripts/updatewal.sh'

alias instp='sudo pacman -S'
alias insty='yay -S'

# APPLICATIONS
alias ls='exa -al'
alias mutt='neomutt'
alias m='neomutt'
alias shutdown='sudo shutdown -h now'
alias v='nvim'
alias r='ranger'
alias t='sudo timeshift --list'
alias ts='~/dotfiles/scripts/snapshot.sh'
alias matrix='cmatrix'
alias screenshot='scrot'

# GIT
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"

# SCRIPTS
alias gr='python ~/dotfiles/scripts/growthrate.py'
alias chat='python ~/mychatgpt/mychatgpt.py'

# VIRTUAL MACHINE
# alias vm='~/dotfiles/scripts/launchvm.sh'
alias vm='~/dotfiles/scripts/looking-glass.sh'
alias vmstart='virsh --connect qemu:///system start win11'
alias vmstop='virsh --connect qemu:///system destroy win11'

# EDIT CONFIG Files
alias confq='vim ~/dotfiles/qtile/config.py'
alias confp='vim ~/dotfiles/picom/picom.conf'
alias confb='vim ~/dotfiles/.bashrc'

# EDIT NOTES
alias notes='vim ~/notes.txt'

# START STARSHIP
eval "$(starship init bash)"

# PYWAL
cat ~/.cache/wal/sequences

# NEOFETCH
neofetch
