# ------------------------------------------------------
# init pywal with default wallpaper
# ------------------------------------------------------
_writeLogHeader "Pywal"
_writeHeader "Pywal"

if [ ! -f ~/.cache/wal/colors-hyprland.conf ]; then
    wal -ei ~/wallpaper/default.jpg
    _writeLogTerminal 0 "Pywal and templates activated."
else
    _writeLogTerminal 0 "Pywal already activated."
fi
echo