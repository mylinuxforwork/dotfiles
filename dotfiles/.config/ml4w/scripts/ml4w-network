#!/usr/bin/env bash

SERVICE="NetworkManager"

if systemctl is-active --quiet "$SERVICE"; then
    echo "✅ $SERVICE is already running."
    nmtui
else
    echo "⚠️  $SERVICE is not running. Attempting to start it..."
    sudo systemctl enable "$SERVICE"
    sudo systemctl start "$SERVICE"
    if systemctl is-active --quiet "$SERVICE"; then
        echo "✅ $SERVICE was successfully started."
        nmtui
    else
        echo "❌ Failed to start $SERVICE. You may need to check 'journalctl -xe' for errors."
        exit 1
    fi
fi
