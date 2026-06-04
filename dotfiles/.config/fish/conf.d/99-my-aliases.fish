# -----------------------------------------------------
# VPN
# -----------------------------------------------------
alias vpn="sudo wg-quick up laptop"
alias vpn-down="sudo wg-quick down laptop"
alias vpn-restart="vpn-down && vpn"
alias vpn-watch="watch -n 2 sudo wg show"

# -----------------------------------------------------
# Package Management
# -----------------------------------------------------
set aur_helper (cat ~/.config/ml4w/settings/aur.sh)

alias update='sudo pacman -Syu'
alias u=update
alias yupdate="$aur_helper -Syu"
alias yu=yupdate

alias install='sudo pacman -S'
alias i=install
alias yinstall="$aur_helper -S"
alias yi=yinstall

alias remove='sudo pacman -Rns'
alias r=remove
alias yremove="$aur_helper -Rns"
alias yr=yremove

alias search='pacman -Ss'
alias s=search
alias ysearch="$aur_helper -Ss"
alias ys=ysearch

alias list='pacman -Qe'

alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# -----------------------------------------------------
# Flatpak
# -----------------------------------------------------
alias finstall='flatpak install flathub'
alias fi=finstall

alias funinstall='flatpak uninstall'
alias fun=funinstall

alias flist='flatpak list'
alias fl=flist

alias fupdate='flatpak update'
alias fup=fupdate

alias frun='flatpak run'

alias fcleanup='flatpak uninstall --unused'

alias finfo='flatpak info'
