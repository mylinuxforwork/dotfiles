# Maintainer: Stephan Raabe <mail@ml4w.com>
pkgname='ml4w-hyprland'
pkgver=2.9.7.0
pkgrel=1
pkgdesc="The ML4W Dotfiles for Hyprland - An advanced and full-featured configuration for the dynamic tiling window manager Hyprland including an easy to use installation script for Arch based Linux distributions. "
arch=(any)
url="https://github.com/mylinuxforwork/dotfiles"
license=('GPL')
options=(!strip)
depends=(
    "pacman-contrib"
    "wget"
    "zip"
    "unzip"
    "gum"
    "rsync"
    "git"
    "figlet"
    "stow"
    "sed"
    "vim"
    "xdg-user-dirs"
    "man-pages"
    "networkmanager"
    "bluez"
    "bluez-utils"
    "hyprland"
    "hyprpaper"
    "hyprlock"
    "hypridle"
    "noto-fonts"
    "xdg-desktop-portal"
    "xdg-desktop-portal-hyprland" 
    "libnotify" 
    "dunst"
    "kitty"
    "qt5-wayland" 
    "qt6-wayland"
)

conflicts=('ml4w-hyprland-git')
makedepends=()
source=("${pkgname}-${pkgver}::https://github.com/mylinuxforwork/dotfiles/archive/refs/tags/${pkgver}.tar.gz")
md5sums=('SKIP')

package() {

    # share
	install -dm 755 ${pkgdir}/usr/share/ml4w-hyprland
	cp -r ${srcdir}/dotfiles-${pkgver}/share/. ${pkgdir}/usr/share/ml4w-hyprland

    # lib
	install -dm 755 ${pkgdir}/usr/lib/ml4w-hyprland
	cp -r ${srcdir}/dotfiles-${pkgver}/lib/. ${pkgdir}/usr/lib/ml4w-hyprland

    # bin
    install -Dm 755 ${srcdir}/dotfiles-${pkgver}/bin/ml4w-hyprland-setup ${pkgdir}/usr/bin/ml4w-hyprland-setup

    # license
    install -Dm 755 ${srcdir}/dotfiles-${pkgver}/LICENSE ${pkgdir}/usr/share/licenses/${pkgname}/LICENSE

    # doc
    install -Dm 755 ${srcdir}/dotfiles-${pkgver}/README.md ${pkgdir}/usr/share/doc/${pkgname}/README.md

    # message
    echo
    echo ":: ML4W Dotfiles ${pkgver} for Hyprland - Main Release"
    echo ":: ---------------------------------------------------"
    echo ":: Please execute the command ml4w-hyprland-setup when the installation is complete."
    echo ":: You can start Hyprland already with command Hyprland or from your display manager."
    echo

}
