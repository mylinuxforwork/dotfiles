#!/bin/bash
#  ____  _          _ _ 
# / ___|| |__   ___| | |
# \___ \| '_ \ / _ \ | |
#  ___) | | | |  __/ | |
# |____/|_| |_|\___|_|_|
#                       

sleep 1

_isInstalledYay() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "\." | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

clear
figlet -f smslant "Shell"

echo ":: Please select your preferred shell"
echo
shell=$(gum choose "bash" "zsh" "Cancel")
# ----------------------------------------------------- 
# Activate bash
# ----------------------------------------------------- 
if [[ $shell == "bash" ]] ;then

    # Change shell to bash
    while ! chsh -s $(which bash); do
        echo "ERROR: Authentication failed. Please enter the correct password."
        sleep 1
    done
    echo ":: Shell is now bash."

    gum spin --spinner dot --title "Please reboot your system." -- sleep 3

# ----------------------------------------------------- 
# Activate zsh
# ----------------------------------------------------- 
elif [[ $shell == "zsh" ]] ;then

    # Change shell to shh
    while ! chsh -s $(which zsh); do
        echo "ERROR: Authentication failed. Please enter the correct password."
        sleep 1
    done
    echo ":: Shell is now zsh."

    # Installing zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo ":: Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.config/zshrc/plugins/zsh-autosuggestions
    else
        echo ":: zsh-autosuggestions already installed"
    fi

    # Installing zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        echo ":: Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zshrc/plugins/zsh-syntax-highlighting
    else
        echo ":: zsh-syntax-highlighting already installed"
    fi

    # Installing fast-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
        echo ":: Installing fast-syntax-highlighting"
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $HOME/.config/zshrc/plugins/fast-syntax-highlighting 
    else
        echo ":: fast-syntax-highlighting already installed"
    fi

    # Installing zsh-completions
    if [ ! -d "$HOME/.config/zshrc/plugins/zsh-completions" ]; then
        echo ":: Installing zsh-completions"
        git clone https://github.com/zsh-users/zsh-completions.git $HOME/.config/zshrc/plugins/zsh-completions
    else
        echo ":: zsh-completions already installed"
    fi

    # Install pkgfile if needed (for command not found)
    if ! command -v pkgfile &> /dev/null; then
        echo ":: Installing pkgfile"
        sudo pacman -S pkgfile
    else
        echo ":: pkgfile already installed"
    fi

    sudo pkgfile -u

    gum spin --spinner dot --title "Please reboot your system." -- sleep 3

# ----------------------------------------------------- 
# Cencel
# ----------------------------------------------------- 
else
    echo ":: Changing shell canceled"
    exit
fi