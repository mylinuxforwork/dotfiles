#!/usr/bin/env bash

# Get the user's video directory based on system settings
DIR="$(xdg-user-dir VIDEOS)"

# Create the directory if it does not exist
if [[ ! -d "$DIR" ]]; then
    mkdir -p "$DIR"
fi

# Temporary file to store the recording filename
TEMP_FILE="/tmp/wf-recorder-filename"

# Function to stop recording and compress the video
cleanup() {
    if pgrep -x "wf-recorder" > /dev/null; then
        pkill --signal SIGINT wf-recorder
        notify-send "📹 Recording stopped"

        # Wait to ensure the file is completely saved
        sleep 2  

        # Retrieve the filename from the temporary file
        if [[ -f "$TEMP_FILE" ]]; then
            MKV_FILE=$(cat "$TEMP_FILE")
            MP4_FILE="${MKV_FILE%.mkv}.mp4"
        else
            notify-send "❌ Error" "Recording file not found!"
            exit 1
        fi

        # Ensure the recorded file exists before proceeding
        if [[ -f "$MKV_FILE" ]]; then
            notify-send "📦 Compressing video..." "Please wait..."
            ffmpeg -i "$MKV_FILE" -c:v libx264 -preset fast -crf 28 -pix_fmt yuv420p -threads $(nproc) -y "$MP4_FILE" && {
                notify-send "✅ Recording saved!" "File: $MP4_FILE"
                echo "✔ Video saved: $MP4_FILE"
                wl-copy < "$MP4_FILE"

                # 🔥 Remove the temporary MKV file after compression
                rm -f "$MKV_FILE"
            }
        else
            notify-send "❌ Error" "Recording file not found!"
        fi
    fi
    exit 0
}

# Capture Ctrl+C (SIGINT) and call the stop function
trap cleanup SIGINT

# If already recording, show menu to stop it
if pgrep -x "wf-recorder" > /dev/null; then
    SELECTION=$(echo -e "⏹ Stop Recording" | rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 1 -width 30 -p "📹 Recording in progress")
    if [[ "$SELECTION" == "⏹ Stop Recording" ]]; then
        cleanup
    else
        exit 0
    fi
fi

# Show rofi menu to choose recording mode
SELECTION=$(echo -e "🎥 Record Active Window\n🎥 Record Selection" | rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "📹 Choose recording mode")

case "$SELECTION" in
    "🎥 Record Active Window")
        MKV_FILE="$DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mkv"
        echo "$MKV_FILE" > "$TEMP_FILE"  # Save the filename temporarily
        wf-recorder -g "$(hyprctl activewindow -j | jq -r '.at[0], .at[1], .size[0], .size[1]' | paste -sd ' ')" -f "$MKV_FILE" &
        notify-send "📹 Recording Active Window" "Press '$mainMod + Shift + R' to stop."
        ;;
    "🎥 Record Selection")
        MKV_FILE="$DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mkv"
        echo "$MKV_FILE" > "$TEMP_FILE"  # Save the filename temporarily
        wf-recorder -g "$(slurp)" -f "$MKV_FILE" &
        notify-send "📹 Recording Selection" "Press '$mainMod + Shift + R' to stop."
        ;;
    *)
        notify-send "❌ Canceled" "No action was selected."
        exit 1
        ;;
esac

