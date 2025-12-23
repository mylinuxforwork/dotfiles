#!/usr/bin/env bash


agents=(
    # In PATH
    polkit-gnome-authentication-agent-1

    # Absolute paths (lib, libexec, lib64)
    /usr/lib/polkit-gnome-authentication-agent-1
    /usr/libexec/polkit-gnome-authentication-agent-1
    /usr/lib64/polkit-gnome-authentication-agent-1
)

for agent in "${agents[@]}"; do
    if [[ "$agent" == /* ]]; then
        if [ -x "$agent" ]; then
            echo ":: Starting polkit agent: $agent"
            "$agent" &
            exit 0
        fi
    else
        if command -v "$agent" >/dev/null 2>&1; then
            echo ":: Starting polkit agent from PATH: $agent"
            "$agent" &
            exit 0
        fi
    fi
done

echo ":: No polkit authentication agent found"
