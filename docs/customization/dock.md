<div align="center" class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

**The ML4W Dotfiles include a configuration for a dock based on nwg-dock-hyprland.**

</div>

![image](/dock.png)

You can activate it by installing the package with:

```sh
yay -S nwg-dock-hyprland
```

Then add the following command to the file `~/.config/hypr/conf/custom.conf`

```sh
exec-once = ~/.config/nwg-dock-hyprland/launch.sh
```

And login to Hyprland again.

