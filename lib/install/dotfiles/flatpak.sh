#!/bin/bash
apps_directory="$1"
cd $apps_directory
flatpak --user -y --reinstall install com.ml4w.calendar.flatpak
