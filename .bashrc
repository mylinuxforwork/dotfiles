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

# APPLICATIONS
alias ls='exa -al'
alias mutt='neomutt'
alias m='neomutt'
alias shutdown='sudo shutdown -h now'
alias v='vim'
alias r='ranger'

# SCRIPTS
alias gr='python ~/dotfiles/scripts/growthrate.py'
alias chat='python ~/mychatgpt/mychatgpt.py'

# VIRTUAL MACHINE
alias vm='~/dotfiles/scripts/launchVM.sh'
alias vmstart='virsh --connect qemu:///system start RDPWindows'
alias vmstop='virsh --connect qemu:///system destroy RDPWindows'
alias win10='xfreerdp /v:Windows10 /size:100% /d: /p:sancho /dynamic-resolution &'

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
