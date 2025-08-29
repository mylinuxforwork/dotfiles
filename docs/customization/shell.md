# Shell (Bash, ZSH, Fish)

The ML4W Dotfiles for Hyprland are shipped with configurations for bash, zsh and fish. You can change the shell from the ML4W Welcome App: Settings/System/Change Shell.

![image](/change-shell.jpg)

## Customize the `.zshrc`

If you want to bring in additional configurations to the zsh settings you can create a file `.zshrc_custom` in your home directory.

For more complex changes try the following possibilities.

The `.zshrc` is loading the files from folder `~/.config/zshrc` in the following order:

* 00-init
* 10-aliases
* 20-customization
* 30-autostart

You can inject a custom file into the loading order. If you want to inject a file after `20-customization`, create a file `25-my-additions`.

If you want to overwrite a shipped file, copy the file into the subfolder custom. That means if you want to add more plugins from `oh-my-posh`, copy the file `20-customization` into the folder custom with the same file name and make your adjustments.

Your customization is protected from ML4W Updates.

### oh-my-zsh

The zsh configuration is based on `oh-my-zsh` to manage plugins and `oh-my-posh` to setup the prompt. The following plugins are installed:

```sh
plugins=(
    git
    sudo
    web-search
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
)
```
### FZF

The keybinding for FZF key is `CTRL + R` for fuzzy history finder

### oh-my-posh

The prompt is based on `oh-my-posh` and the awesome configuration of the minimal but powerful zen prompt by **Dreams of Autonomy**

<iframe width="100%" height="400" src="https://www.youtube.com/embed/9U8LCjuQzdc" 
title="Dreams of Autonomy" frameborder="0" 
allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
allowfullscreen></iframe>

If you want to create your own custom theme save your configuration in `~/.config/ohmyposh` and link it like

```sh
# -----------------------------------------------------
# oh-my-posh prompt
# -----------------------------------------------------
# Custom Theme
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
```

You can use any `oh-my-posh` compatible theme by activating the following line:

```sh
# Shipped Theme
eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/agnoster.omp.json)"
```

## Customize the `.bashrc`

If you want to bring in additional configurations to the bash settings you can create a file `.bashrc_custom` in your home directory.

For more complex changes try the following possibilities.

The `.bashrc` is loading the files from folder `~/.config/bashrc` in the following order:

* 00-init
* 10-aliases
* 20-customization
* 30-autostart

You can inject a custom file into the loading order. If you want to inject a file after `20-customization`, create a file `25-my-additions`.

If you want to overwrite a shipped file, copy the file into the subfolder custom. 

Your customization is protected from ML4W Updates.

