#   ___ _____ ___ _     _____    ____             __ _       
#  / _ \_   _|_ _| |   | ____|  / ___|___  _ __  / _(_) __ _ 
# | | | || |  | || |   |  _|   | |   / _ \| '_ \| |_| |/ _` |
# | |_| || |  | || |___| |___  | |__| (_) | | | |  _| | (_| |
#  \__\_\|_| |___|_____|_____|  \____\___/|_| |_|_| |_|\__, |
#                                                      |___/ 

# Icons: https://fontawesome.com/search?o=r&m=free

import os
import re
import socket
import subprocess
import psutil
import json
from libqtile import hook
from libqtile import qtile
from typing import List  
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.widget import Spacer, Backlight
from libqtile.widget.image import Image
from libqtile.dgroups import simple_key_binder
from pathlib import Path
from libqtile.log_utils import logger
from libqtile.backend.wayland import InputConfig

from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration
from qtile_extras.widget.decorations import PowerLineDecoration
from conf.keyboard import *

# --------------------------------------------------------
# Your configuration
# --------------------------------------------------------

# Keyboard layout in conf/keyboard.py

# Show wlan status bar widget (set to False if wired network)
# show_wlan = True
show_wlan = False

# Show bluetooth status bar widget
# show_bluetooth = True
show_bluetooth = False

# --------------------------------------------------------
# General Variables
# --------------------------------------------------------

# Get home path
home = str(Path.home())

# Get Core name: x11 or wayland
core_name = qtile.core.name
logger.warning("Using config.py with " + core_name)

# --------------------------------------------------------
# Define Status Bar
# --------------------------------------------------------
try:
    wm_bar = Path(home + "/.cache/.qtile_bar_x11.sh").read_text().replace("\n", "")
except:
    wm_bar = "qtile"


logger.warning("Status bar: " + wm_bar)

# --------------------------------------------------------
# Check for Desktop/Laptop
# --------------------------------------------------------

# 3 = Desktop
platform = int(os.popen("cat /sys/class/dmi/id/chassis_type").read())

# --------------------------------------------------------
# Set default apps
# --------------------------------------------------------

terminal = "alacritty"        

# --------------------------------------------------------
# Keybindings
# --------------------------------------------------------

mod = "mod4" # SUPER KEY

keys = [

    # Focus
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window around"),
    
    # Move
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),

    # Swap
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),

    Key([mod], "Print", lazy.spawn(home + "/dotfiles/qtile/scripts/screenshot.sh")),

    # Size
    Key([mod, "control"], "Down", lazy.layout.shrink(), desc="Grow window to the left"),
    Key([mod, "control"], "Up", lazy.layout.grow(), desc="Grow window to the right"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Floating
    Key([mod], "t", lazy.window.toggle_floating(), desc='Toggle floating'),
    
    # Split
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Toggle Layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # Fullscreen
    Key([mod], "f", lazy.window.toggle_fullscreen()),

    #System
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.spawn(home + "/dotfiles/qtile/scripts/powermenu.sh"), desc="Open Powermenu"),
    Key([mod, "shift"], "s", lazy.spawn(home + "/dotfiles/qtile/scripts/barswitcher.sh"), desc="Switch Status Bar"),

    # Apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "control"], "Return", lazy.spawn("rofi -show drun"), desc="Launch Rofi"),
    Key([mod], "b", lazy.spawn("sh " + home + "/dotfiles/.settings/browser.sh"), desc="Launch Browser"),
    Key([mod, "shift"], "w", lazy.spawn(home + "/dotfiles/qtile/scripts/wallpaper.sh"), desc="Update Theme and Wallpaper"),
    Key([mod, "control"], "w", lazy.spawn(home + "/dotfiles/qtile/scripts/wallpaper.sh select"), desc="Select Theme and Wallpaper"),

    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl -q s +20%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl -q s 20%-"))        
]

# --------------------------------------------------------
# Groups
# --------------------------------------------------------

groups = [
    Group("1", layout='monadtall'),
    Group("2", layout='monadtall'),
    Group("3", layout='monadtall'),
    Group("4", layout='monadtall'),
    Group("5", layout='monadtall'),
]

dgroups_key_binder = simple_key_binder(mod)

# --------------------------------------------------------
# Scratchpads
# --------------------------------------------------------

groups.append(ScratchPad("6", [
    DropDown("chatgpt", "chromium --app=https://chat.openai.com", x=0.3, y=0.1, width=0.40, height=0.4, on_focus_lost_hide=False ),
    DropDown("mousepad", "mousepad", x=0.3, y=0.1, width=0.40, height=0.4, on_focus_lost_hide=False ),
    DropDown("terminal", "alacritty", x=0.3, y=0.1, width=0.40, height=0.4, on_focus_lost_hide=False ),
    DropDown("scrcpy", "scrcpy -d", x=0.8, y=0.05, width=0.15, height=0.6, on_focus_lost_hide=False )
]))

keys.extend([
    Key([mod], 'F10', lazy.group["6"].dropdown_toggle("chatgpt")),
    Key([mod], 'F11', lazy.group["6"].dropdown_toggle("mousepad")),
    Key([mod], 'F12', lazy.group["6"].dropdown_toggle("terminal")),
    Key([mod], 'F9', lazy.group["6"].dropdown_toggle("scrcpy"))
])

# --------------------------------------------------------
# Pywal Colors
# --------------------------------------------------------

colors = os.path.expanduser('~/.cache/wal/colors.json')
colordict = json.load(open(colors))
Color0=(colordict['colors']['color0'])
Color1=(colordict['colors']['color1'])
Color2=(colordict['colors']['color2'])
Color3=(colordict['colors']['color3'])
Color4=(colordict['colors']['color4'])
Color5=(colordict['colors']['color5'])
Color6=(colordict['colors']['color6'])
Color7=(colordict['colors']['color7'])
Color8=(colordict['colors']['color8'])
Color9=(colordict['colors']['color9'])
Color10=(colordict['colors']['color10'])
Color11=(colordict['colors']['color11'])
Color12=(colordict['colors']['color12'])
Color13=(colordict['colors']['color13'])
Color14=(colordict['colors']['color14'])
Color15=(colordict['colors']['color15'])

# --------------------------------------------------------
# Setup Layout Theme
# --------------------------------------------------------

layout_theme = { 
    "border_width": 3,
    "margin": 15,
    "border_focus": Color2,
    "border_normal": "FFFFFF",
    "single_border_width": 3
}

# --------------------------------------------------------
# Layouts
# --------------------------------------------------------

layouts = [
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Floating()
]

# --------------------------------------------------------
# Setup Widget Defaults
# --------------------------------------------------------

widget_defaults = dict(
    font="Fira Sans SemiBold",
    fontsize=14,
    padding=3
)
extension_defaults = widget_defaults.copy()

# --------------------------------------------------------
# Decorations
# https://qtile-extras.readthedocs.io/en/stable/manual/how_to/decorations.html
# --------------------------------------------------------

decor_left = {
    "decorations": [
        PowerLineDecoration(
            path="arrow_left"
            # path="rounded_left"
            # path="forward_slash"
            # path="back_slash"
        )
    ],
}

decor_right = {
    "decorations": [
        PowerLineDecoration(
            path="arrow_right"
            # path="rounded_right"
            # path="forward_slash"
            # path="back_slash"
        )
    ],
}

# --------------------------------------------------------
# Widgets
# --------------------------------------------------------

widget_list = [
    widget.TextBox(
        **decor_left,
        background=Color1+".4",
        text='Apps',
        foreground='ffffff',
        desc='',
        padding=10,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("rofi -show drun")},
    ),
    widget.TextBox(
        **decor_left,
        background="#ffffff.4",
        text="  ",
        foreground="000000.6",
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(home + "/dotfiles/qtile/scripts/wallpaper.sh select")},
    ),
    widget.GroupBox(
        **decor_left,
        background="#ffffff.7",
        highlight_method='block',
        highlight='ffffff',
        block_border='ffffff',
        highlight_color=['ffffff','ffffff'],
        block_highlight_text_color='000000',
        foreground='ffffff',
        rounded=False,
        this_current_screen_border='ffffff',
        active='ffffff'
    ),
    widget.TextBox(
        **decor_left,
        background="#ffffff.4",
        text=" ",
        foreground="000000.6",
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("bash " + home + "/dotfiles/.settings/browser.sh")},
    ),
    widget.TextBox(
        **decor_left,
        background="#ffffff.4",
        text=" ",
        foreground="000000.6",
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("bash " + home + "/dotfiles/.settings/filemanager.sh")}
    ),
    
    widget.WindowName(
        **decor_left,
        max_chars=50,
        background=Color2+".4",
        width=400,
        padding=10
    ),
    widget.Spacer(),
    widget.Spacer(
        length=30
    ),
    widget.TextBox(
        **decor_right,
        background="#000000.3"      
    ),    
    widget.Memory(
        **decor_right,
        background=Color10+".4",
        padding=10,        
        measure_mem='G',
        format="{MemUsed:.0f}{mm} ({MemTotal:.0f}{mm})"
    ),
    widget.Volume(
        **decor_right,
        background=Color12+".4",
        padding=10, 
        fmt='Vol: {}',
    ),
    widget.DF(
        **decor_right,
        padding=10, 
        background=Color8+".4",        
        visible_on_warn=False,
        format="{p} {uf}{m} ({r:.0f}%)"
    ),
    widget.Bluetooth(
        **decor_right,
        background=Color2+".4",
        padding=10,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("blueman-manager")},
    ),
    widget.Wlan(
        **decor_right,
        background=Color2+".4",
        padding=10,
        format='{essid} {percent:2.0%}',
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("alacritty -e nmtui")},
    ),
    widget.Clock(
        **decor_right,
        background=Color4+".4",   
        padding=10,      
        format="%Y-%m-%d / %I:%M %p",
    ),
    widget.TextBox(
        **decor_right,
        background=Color2+".4",     
        padding=5,    
        text="",
        fontsize=20,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(home + "/dotfiles/scripts/cliphist.sh")},
    ),
    widget.TextBox(
        **decor_right,
        background=Color2+".4",     
        padding=5,    
        text=" ",
        fontsize=20,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(home + "/dotfiles/qtile/scripts/powermenu.sh")},
    ),
]

# Hide Modules if not on laptop
if (show_wlan == False):
    del widget_list[13:14]

if (show_bluetooth == False):
    del widget_list[12:13]

if (core_name == "x11"):
    del widget_list[13:14]

# --------------------------------------------------------
# Screens
# --------------------------------------------------------

if (wm_bar == "qtile"):
    logger.warning("Loading qtile bar")
    screens = [
        Screen(
            top=bar.Bar(
    		    widget_list,
                30,
                padding=20,
                opacity=0.7,
                border_width=[0, 0, 0, 0],
                margin=[0,0,0,0],
                background="#000000.3"
            ),
        ),
    ]
else:
    screens = [Screen(top=bar.Gap(size=28))]
    if (core_name == "x11"):
        screens = [Screen(top=bar.Gap(size=28))]
    else:
        screens = [Screen(top=bar.Gap(size=0))]

# --------------------------------------------------------
# Drag floating layouts
# --------------------------------------------------------

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# --------------------------------------------------------
# Define floating layouts
# --------------------------------------------------------

floating_layout = layout.Floating(
    border_width=3,
    border_focus=Color2,
    border_normal="FFFFFF",
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

# --------------------------------------------------------
# General Setup
# --------------------------------------------------------

dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.

# --------------------------------------------------------
# Windows Manager Name
# --------------------------------------------------------

wmname = "QTILE"

# --------------------------------------------------------
# Hooks
# --------------------------------------------------------

# HOOK startup
@hook.subscribe.startup_once
def autostart():
    autostartscript = "~/.config/qtile/autostart.sh"
    home = os.path.expanduser(autostartscript)
    subprocess.Popen([home])

