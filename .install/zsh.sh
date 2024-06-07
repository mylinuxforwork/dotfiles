# ------------------------------------------------------
# install zsh and zinit
# ------------------------------------------------------
packagesPacman=("zsh");

echo "Please select the zsh plugin manager:"
zsh_manager=$(gum choose --limit=1 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "oh my zsh" "zinit")
if [[ "${zsh_manager}" == *"oh my zsh"* ]]; then
    source .install/install-packages.sh
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
	_installSymLink zshrc ~/.zshrc ~/dotfiles/.zshrc_ohmyzsh ~/.zshrc
else
    packagesYay=("zinit");
	source .install/install-packages.sh
    _installSymLink zshrc ~/.zshrc ~/dotfiles/.zshrc_zinit ~/.zshrc
fi
_installSymLink p10k ~/.p10k.zsh ~/dotfiles/.p10k.zsh ~/
