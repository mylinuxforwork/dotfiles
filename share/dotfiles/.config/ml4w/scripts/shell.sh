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

    # Change shell to zsh
    while ! chsh -s $(which zsh); do
        echo "ERROR: Authentication failed. Please enter the correct password."
        sleep 1
    done
    echo ":: Shell is now zsh."

    # Check for plugins directory
    if [ ! -d "$HOME/.config/zshrc/plugins" ]; then
        echo ":: Making ZSH Plugin directory"
        mkdir -p $HOME/.config/zshrc/plugins
    else
        echo ":: ZSH Plugin directory already exists"
    fi

    # Installing zsh-autosuggestions
    if [ ! -d "$HOME/.config/zshrc/plugins/zsh-autosuggestions" ]; then
        echo ":: Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.config/zshrc/plugins/zsh-autosuggestions
    else
        echo ":: zsh-autosuggestions already installed"
    fi

    # Installing zsh-syntax-highlighting
    if [ ! -d "$HOME/.config/zshrc/plugins/zsh-syntax-highlighting" ]; then
        echo ":: Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zshrc/plugins/zsh-syntax-highlighting
    else
        echo ":: zsh-syntax-highlighting already installed"
    fi

    # Installing fast-syntax-highlighting
    if [ ! -d "$HOME/.config/zshrc/plugins/fast-syntax-highlighting" ]; then
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

    # Install zsh-plugin-git
    if [ ! -f "$HOME/.config/zshrc/plugins/git.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-git"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/git/git.plugin.zsh -o $HOME/.config/zshrc/plugins/git.plugin.zsh
    else
        echo ":: zsh-plugin-git already installed"
    fi

    # Install zsh-plugin-sudo
    if [ ! -f "$HOME/.config/zshrc/plugins/sudo.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-sudo"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/sudo/sudo.plugin.zsh -o $HOME/.config/zshrc/plugins/sudo.plugin.zsh
    else
        echo ":: zsh-plugin-sudo already installed"
    fi

    # Install zsh-plugin-web-search
    if [ ! -f "$HOME/.config/zshrc/plugins/web-search.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-web-search"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/web-search/web-search.plugin.zsh -o $HOME/.config/zshrc/plugins/web-search.plugin.zsh
    else
        echo ":: zsh-plugin-web-search already installed"
    fi

    # Install zsh-plugin-archlinux
    if [ ! -f "$HOME/.config/zshrc/plugins/archlinux.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-archlinux"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/archlinux/archlinux.plugin.zsh -o $HOME/.config/zshrc/plugins/archlinux.plugin.zsh
    else
        echo ":: zsh-plugin-archlinux already installed"
    fi

    # Install zsh-plugin-copyfile
    if [ ! -f "$HOME/.config/zshrc/plugins/copyfile.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-copyfile"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/copyfile/copyfile.plugin.zsh -o $HOME/.config/zshrc/plugins/copyfile.plugin.zsh
    else
        echo ":: zsh-plugin-copyfile already installed"
    fi

    # Install zsh-plugin-copybuffer
    if [ ! -f "$HOME/.config/zshrc/plugins/copybuffer.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-copybuffer"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/copybuffer/copybuffer.plugin.zsh -o $HOME/.config/zshrc/plugins/copybuffer.plugin.zsh
    else
        echo ":: zsh-plugin-copybuffer already installed"
    fi

    # Install zsh-plugin-dirhistory
    if [ ! -f "$HOME/.config/zshrc/plugins/dirhistory.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-dirhistory"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/dirhistory/dirhistory.plugin.zsh -o $HOME/.config/zshrc/plugins/dirhistory.plugin.zsh
    else
        echo ":: zsh-plugin-dirhistory already installed"
    fi

    # Install zsh-plugin-colored-man-pages
    if [ ! -f "$HOME/.config/zshrc/plugins/colored-man-pages.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-colored-man-pages"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/colored-man-pages/colored-man-pages.plugin.zsh -o $HOME/.config/zshrc/plugins/colored-man-pages.plugin.zsh
    else
        echo ":: zsh-plugin-colored-man-pages already installed"
    fi

    # Install zsh-plugin-command-not-found
    if [ ! -f "$HOME/.config/zshrc/plugins/command-not-found.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-command-not-found"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/command-not-found/command-not-found.plugin.zsh -o $HOME/.config/zshrc/plugins/command-not-found.plugin.zsh
    else
        echo ":: zsh-plugin-command-not-found already installed"
    fi

    # Install zsh-plugin-extract
    if [ ! -f "$HOME/.config/zshrc/plugins/extract.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-extract"
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/extract/extract.plugin.zsh -o $HOME/.config/zshrc/plugins/extract.plugin.zsh
    else
        echo ":: zsh-plugin-extract already installed"
    fi

    # Install zsh-plugin-you-should-use
    if [ ! -f "$HOME/.config/zshrc/plugins/you-should-use.plugin.zsh" ]; then
        echo ":: Installing zsh-plugin-you-should-use"
        curl https://raw.githubusercontent.com/MichaelAquilina/zsh-you-should-use/refs/heads/master/you-should-use.plugin.zsh -o $HOME/.config/zshrc/plugins/you-should-use.plugin.zsh
    else
        echo ":: zsh-plugin-you-should-use already installed"
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