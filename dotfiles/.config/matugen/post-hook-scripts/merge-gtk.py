#!/usr/bin/env python3

import subprocess

def get_current_scheme():
    result = subprocess.run(
        ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

def set_scheme(value):
    subprocess.run([
        "gsettings",
        "set",
        "org.gnome.desktop.interface",
        "color-scheme",
        value
    ])

def main():
    current = get_current_scheme()

    if current == "'prefer-dark'":
        set_scheme("prefer-light")
        set_scheme("prefer-dark")
    else:
        set_scheme("prefer-dark")
        set_scheme("prefer-light")

if __name__ == "__main__":
    main()
