#!/bin/bash

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd
fi

# Download JetBrainsMonoNerdFonts
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
curl -o $HOME/Downloads/JetBrainsMono.tar.xz -OL "$DOWNLOAD_URL" &>> $(_getLogFile)

# Install the fonts
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd &>> $(_getLogFile)
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf $HOME/Downloads/JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd
_writeLogTerminal 0 "JetBrainsMono fonts installed"

# Install FiraCode to enable icons on sequoia theme
if [ ! -d /usr/share/fonts/FiraCode ]; then
    sudo cp -rf $fonts_directory/FiraCode /usr/share/fonts
    _writeLogTerminal 0 "FiraCode fonts installed"
fi

# Update font cache and log the output
fc-cache -v &>> $(_getLogFile)