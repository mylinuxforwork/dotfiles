# ------------------------------------------------------
# install fish
# ------------------------------------------------------
packagesPacman=(
	"fish"
);
packagesYay=(
);
source .install/install-packages.sh

if [ -f ~/dotfiles-versions/$version/.zshrc ]; then
    _installSymLink zshrc ~/.zshrc ~/dotfiles/.zshrc ~
fi
if [ -f ~/dotfiles-versions/$version/.p10k.zsh ]; then
    _installSymLink p10k ~/.p10k.zsh ~/dotfiles/.p10k.zsh ~
fi
