#!/bin/bash
clear
figlet -f smslant "Shell"

_writeMessage "Please select your preferred shell"
echo
shell=$(gum choose "bash" "zsh" "CANCEL")
# ----------------------------------------------------- 
# Activate bash
# ----------------------------------------------------- 
if [[ $shell == "bash" ]]; then

    # Change shell to bash
    while ! chsh -s $(which bash); do
        _writeMessage "ERROR - Authentication failed. Please enter the correct password."
        sleep 1
    done
    _writeMessage "Shell is now bash."

    gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    _selectCategory

# ----------------------------------------------------- 
# Activate zsh
# ----------------------------------------------------- 
elif [[ $shell == "zsh" ]]; then

    # Change shell to shh
    while ! chsh -s $(which zsh); do
        _writeMessage "ERROR - Authentication failed. Please enter the correct password."
        sleep 1
    done
    _writeMessage "Shell is now zsh."

    # Installing oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        _writeMessage "Installing oh-my-zsh"
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        cp ~/.config/ml4w/tpl/.zshrc ~/
    else
        _writeMessage "oh-my-zsh already installed"
    fi

    # Installing zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        _writeMessage "Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        _writeMessage "zsh-autosuggestions already installed"
    fi

    # Installing zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        _writeMessage "Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        _writeMessage "zsh-syntax-highlighting already installed"
    fi

    # Installing fast-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
        _writeMessage "Installing fast-syntax-highlighting"
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting 
    else
        _writeMessage "fast-syntax-highlighting already installed"
    fi

    gum spin --spinner dot --title "Please reboot your system." -- sleep 3
    _selectCategory
# ----------------------------------------------------- 
# Cencel
# ----------------------------------------------------- 
else
    _writeMessage "Changing shell canceled"
    _selectCategory
fi
