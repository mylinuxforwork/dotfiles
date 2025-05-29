The ML4W Dotfiles include a configuration for a dock based on nwg-dock-hyprland.

![image](https://github.com/user-attachments/assets/d9b0838f-b00f-4f95-be9f-d8a1feb601b9)

You can activate it by installing the package with:

```sh
yay -S nwg-dock-hyprland
```

Then add the following command to the file `~/.config/hypr/conf/custom.conf`

```sh
exec-once = ~/.config/nwg-dock-hyprland/launch.sh
```

And login to Hyprland again.

