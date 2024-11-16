#!/bin/bash

# Create installation folder
if [ -d $HOME/Downloads/agsv1 ]; then
    rm -rf $HOME/Downloads/agsv1
fi
mkdir -p $HOME/Downloads/agsv1

# Download PKGBUILD file
wget -P $HOME/Downloads/agsv1 https://raw.githubusercontent.com/kotontrion/PKGBUILDS/main/agsv1/PKGBUILD
# Cd into the folder
cd $HOME/Downloads/agsv1

# Install agsv1
makepkg -si