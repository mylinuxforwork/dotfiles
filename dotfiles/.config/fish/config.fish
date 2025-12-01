alias vpn="sudo wg-quick up laptop"
alias vpn-down="sudo wg-quick down laptop"
alias vpn-restart="vpn-down && vpn"
alias vpn-watch="watch -n 2 sudo wg show"

alias update='sudo pacman -Syu'                # Mise à jour du système
alias install='sudo pacman -S'                 # Installation d’un paquet
alias remove='sudo pacman -Rns'                # Suppression complète d’un paquet
alias search='pacman -Ss'                      # Recherche d’un paquet
alias list='pacman -Qe'                        # Liste des paquets explicitement installés
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # Supprime les paquets orphelins

alias yupdate='yay -Syu'                       # Mise à jour avec AUR
alias yinstall='yay -S'                        # Installation depuis AUR
alias yremove='yay -Rns'                       # Suppression avec yay
alias ysearch='yay -Ss'                        # Recherche avec yay

alias finstall='flatpak install flathub'       # Installe depuis flathub
alias funinstall='flatpak uninstall'           # Désinstalle une appli
alias flist='flatpak list'                     # Liste des applis installées
alias fupdate='flatpak update'                 # Met à jour tout
alias frun='flatpak run'                       # Lance une appli
alias fcleanup='flatpak uninstall --unused'    # Supprime les dépendances inutiles
alias finfo='flatpak info'                     # Affiche les infos d'une appli