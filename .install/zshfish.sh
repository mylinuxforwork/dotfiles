# ------------------------------------------------------
# Select additional shell
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Zsh Fish"
echo -e "${NONE}"
echo "Please select if you want to install zsh or fish."
echo
zshfish=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "zsh" "fish")

if [ -z "${zshfish}" ] ;then
    echo ":: No shell selected. Keep using bash."
else
    echo "Please select your default shell."
	echo
	shell=$(echo "bash\n$zshfish" | gum choose --limit=1 -cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) ")
	sudo chsh -s $(which $shell) $(whoami)
    if [[ $zshfish == *"zsh"* ]]; then
		echo ":: zsh selected"
		source .install/zsh.sh
	fi
	if [[ $zshfish == *"fish"* ]]; then
		echo ":: fish selected"
		source .install/fish.sh
	fi
fi
