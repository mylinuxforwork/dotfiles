#!/bin/bash
clear
figlet -f smslant "Shell"

echo ":: Please select your preferred shell"
echo
shell=$(gum choose "bash" "zsh" "CANCEL")
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
    _selectCategory

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

    # Installing oh-my-posh
    yay -S --noconfirm oh-my-posh

    # Installing oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo ":: Installing oh-my-zsh"
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        cp ~/.config/ml4w/tpl/.zshrc ~/
    else
        echo ":: oh-my-zsh already installed"
    fi

    # Installing zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo ":: Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        echo ":: zsh-autosuggestions already installed"
    fi

    # Installing zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        echo ":: Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo ":: zsh-syntax-highlighting already installed"
    fi

    # Installing fast-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
        echo ":: Installing fast-syntax-highlighting"
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting 
    else
        echo ":: fast-syntax-highlighting already installed"
    fi

    gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    _selectCategory
# ----------------------------------------------------- 
# Cencel
# ----------------------------------------------------- 
else
    echo ":: Changing shell canceled"
    _selectCategory
fi