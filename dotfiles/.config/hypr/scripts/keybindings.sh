#!/usr/bin/env bash
#    __            __   _         ___             
#   / /_____ __ __/ /  (_)__  ___/ (_)__  ___ ____
#  /  '_/ -_) // / _ \/ / _ \/ _  / / _ \/ _ `(_-<
# /_/\_\\__/\_, /_.__/_/_//_/\_,_/_/_//_/\_, /___/
#          /___/                        /___/     
# 

# -----------------------------------------------------
# Get keybindings location based on variation
# -----------------------------------------------------
config_file=$(<~/.config/hypr/conf/keybinding.conf)
config_file=${config_file//source = ~//home/$USER}

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/ml4w/settings/launcher)

# -----------------------------------------------------
# Path to keybindings config file
# -----------------------------------------------------
echo "Reading from: $config_file"

keybinds=$(awk -F'[=#]' '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }

    BEGIN {
        # --- replacement table (order matters) ---
        num_patterns = 0
        patterns[++num_patterns] = "\\$mainMod_L";              replacements[num_patterns] = "SUPER_L"
        patterns[++num_patterns] = "\\$mainMod_R";              replacements[num_patterns] = "SUPER_R"
        patterns[++num_patterns] = "\\$mainMod";                replacements[num_patterns] = "SUPER"

        patterns[++num_patterns] = "bracketleft";               replacements[num_patterns] = "["
        patterns[++num_patterns] = "bracketright";              replacements[num_patterns] = "]"
        patterns[++num_patterns] = "comma";                     replacements[num_patterns] = ","

        patterns[++num_patterns] = "XF86AudioRaiseVolume";      replacements[num_patterns] = "FN_VOLUME_UP"
        patterns[++num_patterns] = "XF86AudioLowerVolume";      replacements[num_patterns] = "FN_VOLUME_DOWN"
        patterns[++num_patterns] = "XF86AudioMicMute";          replacements[num_patterns] = "FN_MIC_MUTE"
        patterns[++num_patterns] = "XF86AudioMute";             replacements[num_patterns] = "FN_MUTE"
        patterns[++num_patterns] = "XF86Sleep";                 replacements[num_patterns] = "FN_SLEEP"
        patterns[++num_patterns] = "XF86Rfkill";                replacements[num_patterns] = "FN_AIRPLANE_MODE"
        patterns[++num_patterns] = "XF86AudioPlayPause";        replacements[num_patterns] = "FN_PLAY_PAUSE"
        patterns[++num_patterns] = "XF86AudioPause";            replacements[num_patterns] = "FN_PAUSE"
        patterns[++num_patterns] = "XF86AudioPlay";             replacements[num_patterns] = "FN_PLAY"
        patterns[++num_patterns] = "XF86AudioNext";             replacements[num_patterns] = "FN_NEXT_TRACK"
        patterns[++num_patterns] = "XF86AudioPrev";             replacements[num_patterns] = "FN_PREVIOUS_TRACK"
        patterns[++num_patterns] = "XF86AudioStop";             replacements[num_patterns] = "FN_STOP"
        patterns[++num_patterns] = "XF86Calculator";            replacements[num_patterns] = "FN_CALCUTALOR"
        patterns[++num_patterns] = "XF86_ScreenSaver";          replacements[num_patterns] = "LOCK_SCREEN"
        patterns[++num_patterns] = "XF86MonBrightnessUp";       replacements[num_patterns] = "FN_BRIGTHNESS_UP"
        patterns[++num_patterns] = "XF86MonBrightnessDown";     replacements[num_patterns] = "FN_BRIGTHNESS_DOWN"

        max_combo_len = 0
    }

    # -------- Collect binds --------
    $1 ~ /^bind[[:alpha:]]*/ {
        # --- extract trailing comment as description ---
        desc = ""
        if (match($0, /#[[:space:]]*(.*)$/, m)) {
            desc = m[1]
            gsub(/^[! ]+|[! ]+$/, "", desc)
            sub(/[ \t]*#.*/, "", $0)
        }

        gsub(/^bind[[:alpha:]]*[[:space:]]*=+[[:space:]]*/, "", $0)
        rhs = trim($0)
        n = split(rhs, a, /[ \t]*,[ \t]*/)

        mods = trim(a[1])
        key  = (n >= 2 ? trim(a[2]) : "")

        dispatcher = (n >= 3 ? trim(a[3]) : "")
        params = ""

        for (j = 4; j <= n; j++) {
            if (length(a[j])) {
            p = trim(a[j])
            if (p != "")
                params = (params ? params ", " : "") p
        }
    }

    # apply replacements
    for (i = 1; i <= num_patterns; i++) {
        gsub(patterns[i], replacements[i], mods)
        gsub(patterns[i], replacements[i], key)
    }

    gsub(/[ \t]+/, " + ", mods)
    mods = toupper(mods)
    key  = toupper(key)

    # modifier-only bind fix
    if (key == mods "_L" || key == mods "_R") {
        key = ""
    }

    combo = (mods && key) ? mods " + " key : (key ? key : mods)

    # final description decision
    if (desc != "")
        description = desc
    else if (dispatcher && params)
        description = dispatcher " " params
    else
        description = dispatcher

    lines[NR] = combo
    descs[NR] = description
    if (length(combo) > max_combo_len)
        max_combo_len = length(combo)
    }

    # -------- Output --------
    END {
        for (i in lines) {
            combo = lines[i]
            desc  = descs[i]

            if (desc != "")
                print combo "\r  " desc
            else
                print combo
        }
    }' "$config_file")


sleep 0.2

if [ "$launcher" == "walker" ]; then
    keybinds=$(echo -n "$keybinds" | tr '\r' ':')
    $HOME/.config/walker/launch.sh -d -N -H -p "Search Keybinds" <<<"$keybinds"
else
    rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/config-compact.rasi <<<"$keybinds"
fi