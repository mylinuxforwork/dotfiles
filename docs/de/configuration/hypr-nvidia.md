# Hyprland und NVIDIA

> [!WARNING]
> Es gibt keine offizielle Hyprland-Unterstützung für NVIDIA-Hardware. Möglicherweise lässt sich Hyprland jedoch zum Laufen bringen. Siehe dazu:
> https://wiki.hyprland.org/Nvidia/

Einige Benutzer berichten, dass Hyprland mit den Dotfiles erfolgreich auf Systemen mit NVIDIA-GPUs unter Verwendung des Open-Source-Treibers "nouveau" installiert werden konnte.

Alternativ bietet ML4W eine BETA-Option an, um den proprietären NVIDIA-Treiber zu installieren (GRUB-Bootloader erforderlich).
Installiere die Dotfiles mit:

```sh
ml4w-hyprland-setup -m nvidia
```

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 8px;">

**Wähle in der ML4W Settings-App unter System → Environment die [folgende Variation](https://github.com/mylinuxforwork/dotfiles/blob/main/share/dotfiles/.config/hypr/conf/environments/nvidia.conf) aus**

Oder setze die entsprechenden Umgebungsvariablen direkt in `hyprland.conf`.

</div>

