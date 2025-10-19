#!/usr/bin/env bash

# Check if elephant is running
if pgrep "elephant" > /dev/null
then
    # Send this diagnostic message to Standard Error (2>&1)
    echo ":: Elephant is running. ::" >&2
else
    # Send this diagnostic message to Standard Error (2>&1)
    echo ":: Elephant is NOT running. ::" >&2
    elephant &
fi

# Send this diagnostic message to Standard Error (2>&1)
echo ":: Launching walker with arguments: $* ::" >&2

# Execute the walker command. Its output will go to stdout.
walker "$@"