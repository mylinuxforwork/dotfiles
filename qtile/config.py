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

# Get home path
home = str(Path.home())

# --------------------------------------------------------
# Define Status Bar
# --------------------------------------------------------
wm_bar = "polybar"
# wm_bar = "qtile"

# --------------------------------------------------------
# Check for Desktop/Laptop
# --------------------------------------------------------
# 3 = Desktop
platform = int(os.popen("cat /sys/class/dmi/id/chassis_type").read())

# --------------------------------------------------------
# Set default apps
# --------------------------------------------------------
terminal = "alacritty"        
browser = "chromium"
# browser = "brave"

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

    Key([mod], "Print", lazy.spawn(home + "/dotfiles/scripts/scrot.sh")),

    # Size
    # Key([mod], "h", lazy.layout.shrink(), lazy.layout.decrease_nmaster(), desc='Shrink window (MonadTall)'),
    # Key([mod], "l", lazy.layout.grow(), lazy.layout.increase_nmaster(), desc='Expand window (MonadTall)'),
    Key([mod, "control"], "Down", lazy.layout.shrink(), desc="Grow window to the left"),
    Key([mod, "control"], "Up", lazy.layout.grow(), desc="Grow window to the right"),
    # Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    # Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
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
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.spawn(home + "/dotfiles/scripts/powermenu.sh"), desc="Open Powermenu"),
    
    # Apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "control"], "Return", lazy.spawn(home + "/dotfiles/scripts/applauncher.sh"), desc="Launch Rofi"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch Browser"),
    Key([mod, "control"], "b", lazy.spawn(home + "/dotfiles/scripts/bravebookmarks.sh"), desc="Rofi Brave Bookmarks"),
    Key([mod], "v", lazy.spawn(home + "/dotfiles/scripts/looking-glass.sh"), desc="Start Looking Glass Client"),
    Key([mod, "shift"], "w", lazy.spawn(home + "/dotfiles/scripts/updatewal.sh"), desc="Update Theme and Wallpaper"),
    Key([mod, "control"], "w", lazy.spawn(home + "/dotfiles/scripts/wallpaper.sh"), desc="Select Theme and Wallpaper"),
    Key([mod, "control"], "t", lazy.spawn(home + "/dotfiles/scripts/templates.sh"), desc="Select Tempate and copy to clipboard"),
#    Key([], 'F10', lazy.spawn("brave --app=https://chat.openai.com"), desc="Open ChatGPT")
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
ColorZ=(colordict['colors']['color0'])
ColorA=(colordict['colors']['color1'])
ColorB=(colordict['colors']['color2'])
ColorC=(colordict['colors']['color3'])
ColorD=(colordict['colors']['color4'])
ColorE=(colordict['colors']['color5'])
ColorF=(colordict['colors']['color6'])
ColorG=(colordict['colors']['color7'])
ColorH=(colordict['colors']['color8'])
ColorI=(colordict['colors']['color9'])

# --------------------------------------------------------
# Setup Layout Theme
# --------------------------------------------------------

layout_theme = { 
    "border_width": 3,
    "margin": 15,
    "border_focus": ColorC,
    "border_normal": "FFFFFF",
    "single_border_width": 3
}

# --------------------------------------------------------
# Layouts
# --------------------------------------------------------

layouts = [
    # layout.Columns(),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
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
# Widgets
# --------------------------------------------------------

widget_list = [
    widget.GroupBox(
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
        text='  ',
        foreground=ColorC,
    ),
    widget.WindowName(),
    widget.Systray(),
    widget.TextBox(
        text='',
        fontsize=18,
        foreground='ffffff',
        desc='Notes',
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(terminal + ' -e vim ' + home + '/notes.txt')},
    ),
    widget.TextBox(
        text='|',
        foreground=ColorC,
    ),
    widget.Volume(
        fmt='Vol: {}',
    ),
    widget.TextBox(
        text='|',
        foreground=ColorC,
    ),
    widget.Memory(
        measure_mem='G',
        format="{MemUsed:.0f}{mm} ({MemTotal:.0f}{mm})"
    ),
    widget.DF(
        visible_on_warn=False,
        format="{p} {uf}{m} ({r:.0f}%)"
    ),
    widget.TextBox(
        text='|',
        foreground=ColorC,
    ),
    widget.Battery(),
    widget.TextBox(
        text='|',
        foreground=ColorC,
    ),
    widget.Clock(
        format="%Y-%m-%d %a %I:%M %p",
    ),
    widget.TextBox(
        text='|',
        foreground=ColorC,
    ),
    widget.QuickExit(
        default_text=" ",
        fontsize=20,
        countdown_start=3,
        countdown_format="{}"
    ),
]

if (platform == 3):
    del widget_list[10:12]

# --------------------------------------------------------
# Screens
# --------------------------------------------------------

if (wm_bar == "polybar"):
    screens = [Screen(top=bar.Gap(size=28))]
else:
    screens = [
        Screen(
            top=bar.Bar(
    		widget_list,
                24,
                opacity=0.7,
                border_width=[3, 0, 3, 0],
                margin=[0,0,0,0]
            ),
        ),
    ]

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
    border_focus=ColorC,
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

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

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
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])

