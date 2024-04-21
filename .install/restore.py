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
        "waybar_custom_timedateformat": "",
        "waybar_workspaces": 5,
        "rofi_bordersize": 3,
        "waybar_network": True,
        "waybar_chatgpt": True,
        "waybar_systray": True,
        "waybar_screenlock": True,
        "waybar_window": True
    }    

    path_name = pathname # Path of Application
    homeFolder = os.path.expanduser('~') # Path to home folder
    dotfiles = homeFolder + "/dotfiles/"
    settings = {}

    def __init__(self):
        # Load settings.json
        settings_file = open(self.dotfiles + ".settings/settings.json")
        settings_arr = json.load(settings_file)
        for row in settings_arr:
            self.settings[row["key"]] = row["value"]

        self.loadSwitchAll("waybar_network","network")
        self.loadSwitchAll("waybar_systray","tray")
        self.loadSwitchAll("waybar_window","hyprland/window")
        self.loadSwitchAll("waybar_screenlock","idle_inhibitor")
        self.loadSwitch("waybar_chatgpt","custom/chatgpt")

        # Waybar Workspaces
        if "waybar_workspaces" in self.settings:
            value = int(self.settings["waybar_workspaces"])
            text = '            "*": ' + str(value)
            self.replaceInFileNext("waybar/modules.json", "// START WORKSPACES", text)
            print (":: waybar_workspaces restored")

        # Rofi BorderSize
        if "rofi_bordersize" in self.settings:
            value = int(self.settings["rofi_bordersize"])
            text = "* { border-width: " + str(value) + "px; }"
            self.overwriteFile(".settings/rofi-border.rasi",text)
            print (":: rofi_bordersize restored")
        
        # Time/DateFormat
        if "waybar_timeformat" in self.settings:
            timeformat = self.settings["waybar_timeformat"]
        else:
            timeformat = self.defaults["waybar_timeformat"]

        if "waybar_dateformat" in self.settings:
            dateformat = self.settings["waybar_dateformat"]
        else:
            dateformat = self.defaults["waybar_dateformat"]

        if "waybar_custom_timedateformat" in self.settings:
            custom_format = self.settings["waybar_custom_timedateformat"]
        else:
            custom_format = self.defaults["waybar_custom_timedateformat"]

        if custom_format != "":
            timedate = '        "format": "{:' + custom_format + '}",'
            self.replaceInFileNext("waybar/modules.json", "TIMEDATEFORMAT", timedate)
        else:
            timedate = '        "format": "{:' + timeformat + ' - ' + dateformat + '}",'
            self.replaceInFileNext("waybar/modules.json", "TIMEDATEFORMAT", timedate)
        print (":: timedate format restored")

    def loadSwitch(self,k,m):
        if k in self.settings:
            if not self.settings[k]:
                self.replaceInFile("waybar/modules.json",'"' + m + '"','            //"' + m + '",')
                print (":: " + k + " restored")

    def loadSwitchAll(self,k,m):
        if k in self.settings:
            if not self.settings[k]:
                for t in self.waybar_themes:
                    self.replaceInFile("waybar/themes/" + t + "/config",'"' + m + '"','        //"' + m + '",')
                print (":: " + k + " restored")

    # Overwrite Text in File
    def overwriteFile(self, f, text):
        file=open(self.dotfiles + f,"w+")
        file.write(text)
        file.close()

    # Replace Text in File
    def replaceInFile(self, f, search, replace):
        file = open(self.dotfiles + f, 'r')
        lines = file.readlines()
        count = 0
        found = 0
        # Strips the newline character
        for l in lines:
            count += 1
            if search in l:
                found = count
        if found > 0:
            lines[found - 1] = replace + "\n"
            with open(self.dotfiles + f, 'w') as file:
                file.writelines(lines)

    # Replace Text in File
    def replaceInFileNext(self, f, search, replace):
        file = open(self.dotfiles + f, 'r')
        lines = file.readlines()
        count = 0
        found = 0
        # Strips the newline character
        for l in lines:
            count += 1
            if search in l:
                found = count
        if found > 0:
            lines[found] = replace + "\n"
            with open(self.dotfiles + f, 'w') as file:
                file.writelines(lines)


ml4wrestore = ML4WRestore()
