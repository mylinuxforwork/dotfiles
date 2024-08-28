#  __  __ _    _  ___        __                _                 
# |  \/  | |  | || \ \      / /  _ __ ___  ___| |_ ___  _ __ ___ 
# | |\/| | |  | || |\ \ /\ / /  | '__/ _ \/ __| __/ _ \| '__/ _ \
# | |  | | |__|__   _\ V  V /   | | |  __/\__ \ || (_) | | |  __/
# |_|  |_|_____| |_|  \_/\_/    |_|  \___||___/\__\___/|_|  \___|
#                                                                

import sys
import subprocess
import os
import json
import pathlib
import shutil

# Get script path
pathname = os.path.dirname(sys.argv[0])

class ML4WRestore:

    waybar_themes = [
        "ml4w-minimal",
        "ml4w",
        "ml4w-blur",
        "ml4w-blur-bottom",
        "ml4w-bottom"
    ]

    defaults = {
        "waybar_timeformat": "%H:%M",
        "waybar_dateformat": "%a",
        "dunst_position": "top-center",
        "waybar_custom_timedateformat": "",
        "waybar_workspaces": 5,
        "rofi_bordersize": 3,
        "waybar_toggle": True,
        "waybar_taskbar": False,
        "waybar_network": True,
        "waybar_chatgpt": True,
        "waybar_systray": True,
        "waybar_screenlock": True,
        "waybar_window": True,
        "hypridle_hyprlock_timeout": 600,
        "hypridle_dpms_timeout": 660,
        "hypridle_suspend_timeout": 1800
    }    

    path_name = pathname # Path of Application
    homeFolder = os.path.expanduser('~') # Path to home folder
    dotfiles = homeFolder + "/.config/"
    settings = {}

    def __init__(self):
        # Load settings.json
        settings_file = open(self.dotfiles + "ml4w/settings/settings.json")
        settings_arr = json.load(settings_file)
        for row in settings_arr:
            self.overwriteFile("ml4w/settings/" + row["key"] + ".sh",row["value"])
            print(":: " + row["key"] + " restored from legacy settings.json")

    def overwriteFile(self, f, text):
        file=open(self.dotfiles + f,"w+")
        file.write(str(text))
        file.close()

ml4wrestore = ML4WRestore()
