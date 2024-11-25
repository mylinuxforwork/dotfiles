# ------------------------------------------------------
# Keyboard Setup
# ------------------------------------------------------
_writeLogHeader "Keyboard"

_setupKeyboardLayout() {
    keyboard_layout=$(localectl list-x11-keymap-layouts | gum filter --height 15 --placeholder "Find your keyboard layout...")
    _writeLogTerminal 1 "Keyboard layout changed to $keyboard_layout"
    _setupKeyboardVariant
}

_setupKeyboardVariant() {
    if gum confirm "Do you want to set a variant of the keyboard?" ; then
        keyboard_variant=$(localectl list-x11-keymap-variants | gum filter --height 15 --placeholder "Find your keyboard layout...")
        _writeLogTerminal 1 "Keyboard variant changed to $keyboard_variant"
    fi
    _confirmKeyboard
}

_confirmKeyboard() {
    echo
    _writeMessage "Current selected keyboard setup:"
    _writeLogTerminal 0 "Keyboard layout: $keyboard_layout"
    _writeLogTerminal 0 "Keyboard variant: $keyboard_variant"
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
        _writeLogTerminal 0 "You have already restored your settings into the new installation."
        _writeLogTerminal 0 "You can repeat the keyboard setup again to choose between a desktop and laptop optimized configuration."
        echo
        if gum confirm "Do you want to proceed with your existing keyboard configuration?" ;then
            setkeyboard=1
        elif [ $? -eq 130 ]; then
            _writeCancel
            exit 130
        else
            _writeSkipped
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
            _writeCancel
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
            _writeLog 0 "Optimized keybindings for french keyboard layout"
        fi

        SEARCH="KEYBOARD_VARIANT"
        REPLACE="$keyboard_variant"
        sed -i "s/$SEARCH/$REPLACE/g" $ml4w_directory/$version/.config/hypr/conf/keyboard.conf

        echo
        _writeLogTerminal 1 "Keyboard setup complete."
        echo
        _writeMessage "PLEASE NOTE: You can update your keyboard layout later in ~/.config/hypr/conf/keyboard.conf"

    fi 
}

if [[ $(_check_update) == "false" ]] ;then
    _writeHeader "Keyboard"
    _keyboard_confirm
fi
