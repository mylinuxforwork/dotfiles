# Sidepad

The Sidepad is a useful feature for quickly and easily accessing a persistent window across all workspaces. 

![image](/sidepad-open.jpg)

When the Sidepad is initialized, the right window frame appears on the left edge of the screen. Keybindings can be used to display and enlarge the window completely.

![image](/sidepad-closed.jpg)

The Sidepad is suitable as a scratchpad replacement, for terminals, and AI assistance that needs to be accessed permanently.

## Key bindings

The ML4W Dotfiles include teh following kebindings for Sidepd:

- SUPER + S: Initialize the sidepad
- SUPER + Shift + S: Opens the sidepad selector
- SUPER + CTRL + right: Opens the sidepad in compact width
- SUPER + CTRL + right: Opens the sidepad in full width
- SUPER + CTRL + left: Closes the sidepad

You will also find a special sectio in the ML4W Sidebar.

## Configuration

Ths Sidepad on the ML4W Dotfile is shipped with the following configurations:

### Terminal

```sh
# Sidepad configuration for Kitty
SIDEPAD_APP="kitty"
SIDEPAD_CLASS="dotfiles-sidepad"
```

### AI assistance 

```sh
# Sidepad configuration for Newelle
# Installation with flatpak install io.github.qwersyk.Newelle
SIDEPAD_APP="flatpak run io.github.qwersyk.Newelle"
SIDEPAD_CLASS="io.github.qwersyk.Newelle"
SIDEPAD_OPTIONS="--width 700"
```
### Browser

```sh
# Sidepad configuration for Firefox
SIDEPAD_APP="firefox --no-remote -P default --name dotfiles-sidepad"
SIDEPAD_CLASS="dotfiles-sidepad"
```

You can add your own custom sidepad configurations in `~/.config/sidepad/pads` The configuration will automatically appear in the Sidepad selector.

## Scripting

The Sidepad script is working also stand-alone without the ML4W Dotfiles.

You can find the script here: https://github.com/mylinuxforwork/dotfiles/tree/main/dotfiles/.config/sidepad

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


You can script the sidepad functionality by creating an own dispatcher script and connect it to your key bindings.

The sidepad dispatcher for the ML4W Dotfiles is available here: https://github.com/mylinuxforwork/dotfiles/blob/main/dotfiles/.config/ml4w/scripts/sidepad.sh


