# ------------------------------------------------------
# Keyboard Setup
# ------------------------------------------------------

_setupKeyboardLayout() {
    keyboard_layout=$(localectl list-x11-keymap-layouts | gum filter --height 15 --placeholder "Find your keyboard layout...")
    echo ":: Keyboard layout changed to $keyboard_layout"
    _setupKeyboardVariant
}

_setupKeyboardVariant() {
    if gum confirm "Do you want to set a variant of the keyboard?" ; then
        keyboard_variant=$(localectl list-x11-keymap-variants | gum filter --height 15 --placeholder "Find your keyboard layout...")
        echo ":: Keyboard variant changed to $keyboard_variant"
    fi
    _confirmKeyboard
}

_confirmKeyboard() {
    echo
    echo "Current selected keyboard setup:"
    echo "Keyboard layout: $keyboard_layout"
    echo "Keyboard variant: $keyboard_variant"
    echo
    if gum confirm "Do you want to proceed with this keyboard setup?" --affirmative "Proceed" --negative "Change" ;then
        return 0
    elif [ $? -eq 130 ]; then
        exit 130
    else
        _setupKeyboardLayout
    fi
}

_keyboard_confirm() {
    setkeyboard=0
    if [ "$restored" == "1" ]; then
        echo ":: You have already restored your settings into the new installation."
        echo "You can repeat the keyboard setup again to choose between a desktop and laptop optimized configuration."
        echo
        if gum confirm "Do you want to proceed with your existing keyboard configuration?" ;then
            setkeyboard=1
        elif [ $? -eq 130 ]; then
            echo ":: Installation canceled."
            exit 130
        else
            echo ":: Keyboard setup skipped."
            setkeyboard=0
        fi
    fi

    if [ "$setkeyboard" == "0" ] ;then

        # Default layout and variants
        keyboard_layout="us"
        keyboard_variant=""

        _confirmKeyboard

        if gum confirm "Are you using a laptop and would you like to enable the laptop presets?"; then
            cp $template_directory/keyboard-laptop.conf $ml4w_directory/$version/.config/hypr/conf/keyboard.conf
            echo "source = ~/.config/hypr/conf/layouts/laptop.conf" > $ml4w_directory/$version/.config/hypr/conf/layout.conf
        elif [ $? -eq 130 ]; then
            echo ":: Installation canceled."
            exit 130
        else
            cp $template_directory/keyboard-default.conf $ml4w_directory/$version/.config/hypr/conf/keyboard.conf
        fi

        SEARCH="KEYBOARD_LAYOUT"
        REPLACE="$keyboard_layout"
        sed -i "s/$SEARCH/$REPLACE/g" $ml4w_directory/$version/.config/hypr/conf/keyboard.conf

        # Set french keyboard variation
        if [[ "$keyboard_layout" == "fr" ]] ;then
            echo "source = ~/.config/hypr/conf/keybindings/fr.conf" > $ml4w_directory/$version/.config/hypr/conf/keybinding.conf
            echo ":: Optimized keybindings for french keyboard layout"
        fi

        SEARCH="KEYBOARD_VARIANT"
        REPLACE="$keyboard_variant"
        sed -i "s/$SEARCH/$REPLACE/g" $ml4w_directory/$version/.config/hypr/conf/keyboard.conf

        echo
        echo ":: Keyboard setup complete."
        echo
        echo "PLEASE NOTE: You can update your keyboard layout later in ~/.config/hypr/conf/keyboard.conf"

    fi 
}

if [[ $(_check_update) == "false" ]] ;then
    echo -e "${GREEN}"
    figlet -f smslant "Keyboard"
    echo -e "${NONE}"
    if [ -z $automation_keyboard ] ;then
        _keyboard_confirm
    else
        if [[ "$automation_keyboard" = true ]] && [[ "$restored" = 1 ]] ;then
            echo ":: AUTOMATION: Proceed with existing keyboard configuration."
        else
            _keyboard_confirm        
        fi
    fi
fi
