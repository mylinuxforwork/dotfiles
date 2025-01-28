#!/bin/bash
apps_directory="$1"
cd $apps_directory
flatpak --user -y --reinstall install com.ml4w.calendar.flatpak
echo ":: com.ml4w.calendar.flatpak installed"
flatpak --user -y --reinstall install com.ml4w.welcome.flatpak
echo ":: com.ml4w.welcome.flatpak installed"
flatpak --user -y --reinstall install com.ml4w.settings.flatpak
echo ":: com.ml4w.setting.flatpak installed"
