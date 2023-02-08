#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# ALIASES
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias ls='exa -al'
alias mutt='neomutt'
alias m='neomutt'
alias shutdown='sudo shutdown -h now'
alias v='vim'
alias w='wal -i ~/wallpaper/'

alias gr='python ~/dotfiles/scripts/growthrate.py'

alias vm='~/dotfiles/scripts/launchVM.sh'
alias vmstart='virsh --connect qemu:///system start RDPWindows'
alias vmstop='virsh --connect qemu:///system destroy RDPWindows'
alias win10='xfreerdp /v:Windows10 /size:100% /d: /p:sancho /dynamic-resolution &'

alias qc='vim ~/dotfiles/qtile/config.py'
alias pc='vim ~/dotfiles/picom/picom.conf'

# START STARSHIP
eval "$(starship init bash)"

# PyWal
cat ~/.cache/wal/sequences

# START NEOFETCH
neofetch
