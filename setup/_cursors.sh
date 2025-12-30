#!/usr/bin/env bash
# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

# --------------------------------------------------------------
# Bibata Cursors
# --------------------------------------------------------------

download_folder="$HOME/Downloads/bibata-cursors"
bibata_url="https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/"

if [ -d $download_folder ]; then
    rm -rf $download_folder
fi
mkdir -p $download_folder

wget -P $download_folder $bibata_url/Bibata-Modern-Amber.tar.xz
wget -P $download_folder $bibata_url/Bibata-Modern-Classic.tar.xz
wget -P $download_folder $bibata_url/Bibata-Modern-Ice.tar.xz

if [ ! -d ~/.local/share/icons/ ]; then
    mkdir -p ~/.local/share/icons/
fi

if [ -d ~/.local/share/icons/Bibata-Modern-Amber ]; then
    rm -rf ~/.local/share/icons/Bibata-Modern-Amber
fi
if [ -d ~/.local/share/icons/Bibata-Modern-Classic ]; then
    rm -rf ~/.local/share/icons/Bibata-Modern-Classic
fi
if [ -d ~/.local/share/icons/Bibata-Modern-Amber ]; then
    rm -rf ~/.local/share/icons/Bibata-Modern-Ice
fi

tar -xf $download_folder/Bibata-Modern-Amber.tar.xz -C ~/.local/share/icons/
tar -xf $download_folder/Bibata-Modern-Classic.tar.xz -C ~/.local/share/icons/
tar -xf $download_folder/Bibata-Modern-Ice.tar.xz -C ~/.local/share/icons/

if [ -d $download_folder ]; then
    rm -rf $download_folder
fi

# --------------------------------------------------------------
# Arc Cursors
# --------------------------------------------------------------

if [ -d ~/.local/share/icons/ArcAurora-cursors ]; then
    rm -rf ~/.local/share/icons/ArcAurora-cursors
fi

if [ -d ~/.local/share/icons/ArcDusk-cursors ]; then
    rm -rf ~/.local/share/icons/ArcDusk-cursors
fi

if [ -d ~/.local/share/icons/ArcStarry-cursors ]; then
    rm -rf ~/.local/share/icons/ArcStarry-cursors
fi

unzip $SCRIPT_DIR/cursors/ArcAurora-cursors.zip -d ~/.local/share/icons/
unzip $SCRIPT_DIR/cursors/ArcDusk-cursors.zip -d ~/.local/share/icons/
unzip $SCRIPT_DIR/cursors/ArcStarry-cursors.zip -d ~/.local/share/icons/