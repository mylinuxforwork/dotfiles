#!/bin/bash

if [[ $(_isInstalledAUR "aylurs-gtk-shell") == 0 ]]; then
    $aur_helper -R --noconfirm aylurs-gtk-shell
fi

if [[ ! $(_isInstalledAUR "agsv1") == 0 ]]; then
    if [ -d $HOME/Downloads/agsv1 ]; then
        rm -rf $HOME/Downloads/agsv1
    fi
    mkdir -p $HOME/Downloads/agsv1
    cp $packages_directory/agsv1/PKGBUILD $HOME/Downloads/agsv1
    $install_directory/packages/ags.sh
fi




