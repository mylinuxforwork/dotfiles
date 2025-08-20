# Sidepad

## Key bindings

The ML4W Dotfiles include teh following kebindings for Sidepd:

- SUPER + S: Initialize the sidepad
- SUPER + Shift + S: Opens the sidepad selector
- SUPER + CTRL + right: Opens the sidepad in compact width
- SUPER + CTRL + right: Opens the sidepad in full width
- SUPER + CTRL + left: Closes the sidepad

You will also find a special sectio in the ML4W Sidebar.

## Configuration

You can add your own custom sidepad configuration in ~/.config/sidepad/pads The configuration will automatically appear in the Sidepad selector.

```sh
# Sidepad configuration for Kitty
SIDEPAD_APP="kitty"
SIDEPAD_CLASS="dotfiles-sidepad"
```

```sh
# Sidepad configuration for Newelle
SIDEPAD_APP="flatpak run io.github.qwersyk.Newelle"
SIDEPAD_CLASS="io.github.qwersyk.Newelle"
SIDEPAD_OPTIONS="--width 700"
```

```sh
# Sidepad configuration for Firefox
SIDEPAD_APP="firefox --no-remote -P default --name dotfiles-sidepad"
SIDEPAD_CLASS="dotfiles-sidepad"
```

```sh
Options:
  --class <name>         Override the window class (Default: dotfiles-sidepad)
  --hidden-gap <px>      Override the hidden left gap (Default: 10)
  --visible-gap <px>     Override the visible left gap (Default: 20)
  --width <px>           Override the target width (Default: 500)
  --width-max <px>       Override the maximum target width (Default: 1000)
  --top-gap <px>         Override the top gap (Default: 76)
  --bottom-gap <px>      Override the bottom gap (Default: 91)
  --hide                 Force the window to the hidden state.
  --kill                 Kills the running app with WINDOW_CLASS.
  -h, --help             Display this help and exit
```
# Scripting

You can script the sidepad functionality by creating an own dispatcher script and connect it to your key bindings.

The sidepad dispatcher for the ML4W Dotfiles is available here: 


