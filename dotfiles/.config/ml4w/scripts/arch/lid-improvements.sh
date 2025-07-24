#!/bin/bash
while IFS= read -r line; do
    # If the line starts with # and the next line is not the lines to be added
    if [[ $line == \#HandleLidSwitchDocked=ignore ]]; then
        # Add the new lines
        echo "HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf >/dev/null
    fi
    if [[ $line == \#HoldoffTimeoutSec=5s ]]; then
        # Add the new lines
        echo "HoldoffTimeoutSec=5s" | sudo tee -a /etc/systemd/logind.conf >/dev/null
    fi
done </etc/systemd/logind.conf
