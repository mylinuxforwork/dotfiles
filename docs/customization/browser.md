# Default Browser

<div align="center" class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

**The default browser is Firefox. But you can use any browser as your default browser.**

</div>

As an example, let's install brave.

```sh
yay -S brave-bin
```

Then open the ML4W Dotfiles Settings app with `SUPER+CTRL+S`, open the waybar tab, scroll down and change the browser to brave.

![image](/browser.png)

Then execute the following command in a terminal:

```sh
xdg-settings set default-web-browser brave.desktop
```

To change the Waybar quicklink for the browser follow the instructions from `Customize Waybar Section` 
