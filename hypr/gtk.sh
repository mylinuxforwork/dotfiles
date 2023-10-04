#!/bin/sh
gnome_schema="org.gnome.desktop.interface"

gsettings set "$gnome_schema" gtk-theme "Breeze-Dark"
gsettings set "$gnome_schema" icon-theme "kora"
gsettings set "$gnome_schema" cursor-theme "Bibata-Modern-Ice"
gsettings set "$gnome_schema" font-name "Cantarell 11"
gsettings set "$gnome_schema" color-scheme "prefer-dark"
