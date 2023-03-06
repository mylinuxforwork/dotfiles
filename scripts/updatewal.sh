# ~/.bashrc

echo "Changing theme..."
# Update Wallpaper with pywal
wal -q -i ~/wallpaper/

# Wait for 1 sec
sleep 1

# Reload qtile to color bar
qtile cmd-obj -o cmd -f reload_config

echo "Done."
