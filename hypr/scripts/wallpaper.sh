#!/bin/bash
#                _ _                              
# __      ____ _| | |_ __   __ _ _ __   ___ _ __  
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                   |_|         |_|               
#  
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Get wallpaper folder
# ----------------------------------------------------- 
wallpaper_folder="$HOME/wallpaper"
if [ -f ~/dotfiles/.settings/wallpaper-folder.sh ] ;then
    source ~/dotfiles/.settings/wallpaper-folder.sh
fi

# ----------------------------------------------------- 
# Check to use wallpaper cache
# ----------------------------------------------------- 
use_cache=0
if [ -f $HOME/dotfiles/.settings/wallpaper_cache ] ;then
    use_cache=1
fi

if [ "$use_cache" == "1" ] ;then
    echo ":: Using Wallpaper Cache"
else
    echo ":: Wallpaper Cache disabled"
fi

# ----------------------------------------------------- 
# File and folder names
# ----------------------------------------------------- 
force_generate=0

generated_versions="$HOME/.cache/ml4w-wallpaper-generated"
cache_file="$HOME/.cache/current_wallpaper"
used_wallpaper="$HOME/.cache/used_wallpaper"
blurred_wallpaper="$HOME/.cache/blurred_wallpaper.png"
square_wallpaper="$HOME/.cache/square_wallpaper.png"

rasi_file="$HOME/.cache/current_wallpaper.rasi"
blur_file="$HOME/dotfiles/.settings/blur.sh"

blur="50x30"
blur=$(cat $blur_file)

# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "$wallpaper_folder/default.jpg" > "$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
    echo "* { current-image: url(\"$wallpaper_folder/default.jpg\", height); }" > "$rasi_file"
fi

# Create folder with generated versions of wallpaper if not exists
if [ ! -d $generated_versions ] ;then
    mkdir $generated_versions
fi

# ----------------------------------------------------- 
# Current wallpaper
# ----------------------------------------------------- 
current_wallpaper=$(cat "$cache_file")
current_wallpaper_filename=$(echo $current_wallpaper | sed "s|$wallpaper_folder/||g")

# ----------------------------------------------------- 
# Select Wallpaper
# ----------------------------------------------------- 
case $1 in

    # Remove current wallpaper cached files for regeneration
    "regenerate")
        sleep 1
        force_generate=1
        echo ":: Cached files for current wallpaper $current_wallpaper_filename will be regenerated"
        notify-send "Cached files for current wallpaper $current_wallpaper_filename will be regenerated"
    ;;

    # Empty the cache folder completely
    "clearcache")
        sleep 1
        rm $generated_versions/*
        echo ":: Wallpaper cache cleared"
        notify-send "Wallpaper cache cleared"
    ;;

    # Load wallpaper from .cache of last session 
    "init")
        sleep 1
        if [ -f $cache_file ]; then
            wal -q -i $current_wallpaper
        else
            wal -q -i $wallpaper_folder/
        fi
    ;;

    # Select wallpaper with rofi
    "select")
        sleep 0.2
        selected=$( find "$wallpaper_folder" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec basename {} \; | sort -R | while read rfile
        do
            if [ -f $generated_versions/square-${rfile}.png ] ;then
                echo -en "$rfile\x00icon\x1f$generated_versions/square-${rfile}.png\n"
            else
                echo -en "$rfile\x00icon\x1f$wallpaper_folder/${rfile}\n"
            fi
        done | rofi -dmenu -i -replace -config ~/dotfiles/rofi/config-wallpaper.rasi)
        if [ ! "$selected" ]; then
            echo "No wallpaper selected"
            exit
        fi
        wal -q -i $wallpaper_folder/$selected
    ;;

    # Randomly select wallpaper 
    *)
        wal -q -i $wallpaper_folder/
    ;;

esac

# ----------------------------------------------------- 
# Execute pywal
# ----------------------------------------------------- 

source "$HOME/.cache/wal/colors.sh"

# ----------------------------------------------------- 
# Selected Wallpaper
# ----------------------------------------------------- 

echo ":: Setting up wallpaper with $wallpaper"

# ----------------------------------------------------- 
# Get selected wallpaper image name
# ----------------------------------------------------- 

newwall=$(echo $wallpaper | sed "s|$wallpaper_folder/||g")

# ----------------------------------------------------- 
# Copy selected wallpaper to .cache
# ----------------------------------------------------- 

echo ":: Copy $wallpaper to .cache"
cp $wallpaper $HOME/.cache/
mv $HOME/.cache/$newwall $used_wallpaper

# ----------------------------------------------------- 
# Reload waybar with new colors
# -----------------------------------------------------
~/dotfiles/waybar/launch.sh

# ----------------------------------------------------- 
# swww transition type
# -----------------------------------------------------
transition_type="wipe"
# transition_type="outer"
# transition_type="random"

# ----------------------------------------------------- 
# Wallpaper Effects
# -----------------------------------------------------

if [ -f $HOME/dotfiles/.settings/wallpaper-effect.sh ] ;then
    effect=$(cat $HOME/dotfiles/.settings/wallpaper-effect.sh)
    if [ ! "$effect" == "off" ] ;then
        if [ -f $generated_versions/$effect-$newwall ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ] ;then
            echo ":: Use cached wallpaper $effect_$newwall"
        else
            echo ":: Generate new cached wallpaper $effect-$newwall with effect $effect"
            if [ "$1" == "init" ] ;then
                echo ":: Init"
            else
                dunstify "Using wallpaper effect $effect..." "with image $newwall" -h int:value:10 -h string:x-dunst-stack-tag:wallpaper
            fi
            source $HOME/dotfiles/hypr/effects/wallpaper/$effect
            cp $used_wallpaper $generated_versions/$effect-$newwall
        fi
        cp $generated_versions/$effect-$newwall $used_wallpaper
    else
        echo ":: Wallpaper effect is set to off"
    fi
fi

# ----------------------------------------------------- 
# Set new wallpaper with defined wallpaper engine
# -----------------------------------------------------

wallpaper_engine=$(cat $HOME/dotfiles/.settings/wallpaper-engine.sh)
if [ "$wallpaper_engine" == "swww" ] ;then
    # swww
    echo ":: Using swww"
    swww img $used_wallpaper \
        --transition-bezier .43,1.19,1,.4 \
        --transition-fps=60 \
        --transition-type=$transition_type \
        --transition-duration=0.7 \
        --transition-pos "$( hyprctl cursorpos )"
elif [ "$wallpaper_engine" == "hyprpaper" ] ;then
    # hyprpaper
    echo ":: Using hyprpaper"
    killall hyprpaper
    wal_tpl=$(cat $HOME/dotfiles/.settings/hyprpaper.tpl)
    output=${wal_tpl//WALLPAPER/$used_wallpaper}
    echo "$output" > $HOME/dotfiles/hypr/hyprpaper.conf
    hyprpaper & > /dev/null 2>&1
else
    echo ":: Wallpaper Engine disabled"
fi

# Notify that the wallpaper will changed
if [ "$1" == "init" ] ;then
    echo ":: Init"
else
    sleep 1
    dunstify "Changing wallpaper ..." "with image $newwall" -h int:value:25 -h string:x-dunst-stack-tag:wallpaper
    
    # ----------------------------------------------------- 
    # Reload Hyprctl.sh
    # -----------------------------------------------------
    $HOME/.config/ml4w-hyprland-settings/hyprctl.sh &
fi

# ----------------------------------------------------- 
# Created blurred wallpaper
# -----------------------------------------------------

if [ -f $generated_versions/blur-$blur-$newwall.png ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ] ;then
    echo ":: Use cached wallpaper blur-$blur-$newwall.png"
else
    echo ":: Generate new cached wallpaper blur-$blur-$newwall with blur $blur"
    if [ "$1" == "init" ] ;then
        echo ":: Init"
    else
        dunstify "Creating blurred version ..." "with image $newwall" -h int:value:50 -h string:x-dunst-stack-tag:wallpaper
    fi    
    magick $used_wallpaper -resize 75% $blurred_wallpaper
    echo ":: Resized to 75%"
    if [ ! "$blur" == "0x0" ] ;then
        magick $blurred_wallpaper -blur $blur $blurred_wallpaper
        cp $blurred_wallpaper $generated_versions/blur-$blur-$newwall.png
        echo ":: Blurred"
    fi
    cp $generated_versions/blur-$blur-$newwall.png $blurred_wallpaper
fi
cp $generated_versions/blur-$blur-$newwall.png $blurred_wallpaper

# ----------------------------------------------------- 
# Created square wallpaper
# -----------------------------------------------------

if [ -f $generated_versions/square-$newwall.png ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ] ;then
    echo ":: Use cached wallpaper square-$newwall.png"
else
    echo ":: Generate new cached wallpaper square-$newwall"
    if [ "$1" == "init" ] ;then
        echo ":: Init"
    else
        dunstify "Creating square version ..." "with image $newwall" -h int:value:75 -h string:x-dunst-stack-tag:wallpaper
    fi
    magick $wallpaper -gravity Center -extent 1:1 $square_wallpaper
    cp $square_wallpaper $generated_versions/square-$newwall.png
fi
cp $generated_versions/square-$newwall.png $square_wallpaper

# ----------------------------------------------------- 
# Write selected wallpaper into .cache files
# ----------------------------------------------------- 

echo "$wallpaper" > "$cache_file"
echo "* { current-image: url(\"$blurred_wallpaper\", height); }" > "$rasi_file"

# ----------------------------------------------------- 
# Send complete notification
# ----------------------------------------------------- 

if [ "$1" == "init" ] ;then
    echo ":: Init"
else
    dunstify "Wallpaper procedure complete!" "with image $newwall" -h int:value:100 -h string:x-dunst-stack-tag:wallpaper
fi

echo "DONE!"