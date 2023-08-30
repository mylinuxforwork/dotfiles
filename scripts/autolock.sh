#!/bin/bash
#     _         _        _            _     
#    / \  _   _| |_ ___ | | ___   ___| | __ 
#   / _ \| | | | __/ _ \| |/ _ \ / __| |/ / 
#  / ___ \ |_| | || (_) | | (_) | (__|   <  
# /_/   \_\__,_|\__\___/|_|\___/ \___|_|\_\ 
#                                           
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

pkill xautolock

xautolock -time 10 -locker "swaylock -i ~/.cache/current_wallpaper.jpg" -notify 30 -notifier "notify-send 'Screen will be locked soon.' 'Locking screen in 30 seconds'"
