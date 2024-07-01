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
# Get selected wallpaper
# ----------------------------------------------------- 
echo ":: Using wallpaper $1"
wallpaper=$1

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
blurred_wallpaper="$HOME/.cache/blurred_wallpaper.png"
square_wallpaper="$HOME/.cache/square_wallpaper.png"
rasi_file="$HOME/.cache/current_wallpaper.rasi"
blur_file="$HOME/dotfiles/.settings/blur.sh"

blur="50x30"
blur=$(cat $blur_file)

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
current_wallpaper=$wallpaper
current_wallpaper_filename=$(basename $current_wallpaper)
echo ":: Current Wallpaper: $current_wallpaper"
echo ":: Current Wallpaper Filename: $current_wallpaper_filename"
newwall=$current_wallpaper_filename

# ----------------------------------------------------- 
# Copy path of current wallpaper to cache file
# ----------------------------------------------------- 
if [ ! -f $cache_file ] ;then
    touch $cache_file
fi
echo "$current_wallpaper" > $cache_file
echo ":: Path of current wallpaper copied to $cache_file"

# ----------------------------------------------------- 
# Execute pywal
# ----------------------------------------------------- 
echo ":: Execute wallpaper"
wal -q -i $wallpaper
source "$HOME/.cache/wal/colors.sh"

# ----------------------------------------------------- 
# Wallpaper Effects
# -----------------------------------------------------

if [ -f $HOME/dotfiles/.settings/wallpaper-effect.sh ] ;then
    effect=$(cat $HOME/dotfiles/.settings/wallpaper-effect.sh)
    if [ ! "$effect" == "off" ] ;then
        used_wallpaper=$generated_versions/$effect-$newwall
        if [ -f $generated_versions/$effect-$newwall ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ] ;then
            echo ":: Use cached wallpaper $effect-$newwall"
        else
            echo ":: Generate new cached wallpaper $effect-$newwall with effect $effect"
            if [ "$1" == "init" ] ;then
                echo ":: Init"
            else
                dunstify "Using wallpaper effect $effect..." "with image $newwall" -h int:value:10 -h string:x-dunst-stack-tag:wallpaper
            fi
            source $HOME/dotfiles/hypr/effects/wallpaper/$effect
        fi
        echo ":: Loading wallpaper $generated_versions/$effect-$newwall with effect $effect"
        killall -e hyprpaper & 
        sleep 1; 
        wal_tpl=$(cat $HOME/dotfiles/.settings/hyprpaper.tpl)
        echo $wal_tpl
        output=${wal_tpl//WALLPAPER/$used_wallpaper}
        echo "$output" > $HOME/dotfiles/hypr/hyprpaper.conf
        hyprpaper & > /dev/null 2>&1
    else
        echo ":: Wallpaper effect is set to off"
    fi
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
    magick $wallpaper -resize 75% $blurred_wallpaper
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
