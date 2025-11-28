#!/usr/bin/env bash

rm -f ~/.bashrc
rm -f ~/.zshrc
rm -rf ~/.config/fish/
rm -rf ~/.config/hypr/
rm -rf ~/.config/kitty

cd ..
stow dotfiles
