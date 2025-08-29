# Hyprland and NVIDIA

> [!CAUTION]
> There is no official Hyprland support for Nvidia hardware. However, you might make it work properly following this page.
https://wiki.hyprland.org/Nvidia/

Users have reported that Hyprland with dotfiles could be installed successfully on setups with NVDIA GPUs using the nouveau open source drivers. 

You can also try a ML4W Dotfiles BETA feature to install the NVIDIA proprietary driver (grub bootloader required).
Install the dotfiles with: 

```sh
ml4w-hyprland-setup -m nvidia
```

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 8px;">

**Please select the [following variation](https://github.com/mylinuxforwork/dotfiles/blob/main/share/dotfiles/.config/hypr/conf/environments/nvidia.conf
) in the ML4W Settings app (system/environment)**
Or
 set the included environment variables in hyprland.conf

</div>

