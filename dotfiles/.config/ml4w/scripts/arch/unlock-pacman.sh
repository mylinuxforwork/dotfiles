#!/bin/bash
sleep 1
if [ -f /var/lib/pacman/db.lck ]; then
    sudo rm /var/lib/pacman/db.lck
    echo ":: Unlock complete"
else
    echo ":: Pacman database is not locked"
fi
sleep 3
