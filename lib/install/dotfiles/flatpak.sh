#!/bin/bash
apps_directory="$1"
log_file="$2"

# Install Runtime
echo ":: Installing runtime"
flatpak -y install org.gnome.Platform/x86_64/47 &>> $log_file

# Install Apps
cd $apps_directory
flatpak --user -y --reinstall install com.ml4w.calendar.flatpak &>> $log_file
echo ":: com.ml4w.calendar.flatpak installed"
flatpak --user -y --reinstall install com.ml4w.welcome.flatpak &>> $log_file
echo ":: com.ml4w.welcome.flatpak installed"
flatpak --user -y --reinstall install com.ml4w.settings.flatpak &>> $log_file
echo ":: com.ml4w.setting.flatpak installed"
flatpak --user -y --reinstall install com.ml4w.sidebar.flatpak &>> $log_file
echo ":: com.ml4w.sidebar.flatpak installed"
