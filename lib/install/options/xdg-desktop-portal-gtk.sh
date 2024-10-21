clear
echo -e "${GREEN}"
figlet -f smslant "xdg-desktop"
echo -e "${NONE}"
echo "The xdg-desktop-portal-gtk is required to enable dark theme on Libadwaita/GTK4 Apps."
echo
if gum confirm "Do you want to install it now?" ;then
    $aur_helper -S xdg-desktop-portal-gtk
fi
_selectCategory