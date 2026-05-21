#!/usr/bin/env bash

# 1. Define fallbacks as explicit functions to prevent quote-stripping issues
lock_action()     { pidof hyprlock || hyprlock; }
suspend_action()  { systemctl suspend; }
logout_action()   { hyprctl dispatch 'hl.dsp.exit()'; }
reboot_action()   { systemctl reboot; }
poweroff_action() { systemctl poweroff; }

# 2. Dynamic Check: If hyprshutdown is present, override the functions directly
if command -v hyprshutdown &> /dev/null; then
    logout_action()   { hyprshutdown; }
    reboot_action()   { hyprshutdown -t 'Restarting...' --post-cmd 'reboot'; }
    poweroff_action() { hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'; }
fi

# Help menu output
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTION]

A capsule wrapper for system power management features.

Options:
  -l, --lock        Lock the screen using hyprlock
  -s, --suspend     Suspend the system via systemctl
  -e, --logout      Gracefully exit the desktop environment
  -r, --reboot      Reboot the machine
  -p, --poweroff    Power off the machine completely
  -h, --help        Display this help menu
EOF
}

# 3. Clean execution map without using 'eval'
case "$1" in
    -l|--lock)
        lock_action
        ;;
    -s|--suspend)
        suspend_action
        ;;
    -e|--logout)
        logout_action
        ;;
    -r|--reboot)
        reboot_action
        ;;
    -p|--poweroff)
        poweroff_action
        ;;
    -h|--help|"")
        show_help
        ;;
    *)
        echo "Error: Unknown option '$1'" >&2
        show_help
        exit 1
        ;;
esac