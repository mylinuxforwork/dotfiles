{ config, pkgs, ... }:

{
  # Set a state version to prevent a warning
  home.stateVersion = "24.05"; # Replace with your NixOS version

  # The list of dependencies for Hyprland
  home.packages = with pkgs; [
    wget
    unzip
    gum
    rsync
    git
    figlet
    xdg-user-dirs
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-extra
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    libnotify
    kitty
    qt5-wayland
    qt6-wayland
    fastfetch
    eza
    python3
    python3Packages.gobject
    python3Packages.screeninfo
    tumbler
    brightnessctl
    nm-connection-editor
    network-manager-applet
    imagemagick
    jq
    xclip
    neovim
    htop
    blueman
    grim
    slurp
    cliphist
    nwg-look
    qt6ct
    waybar
    rofi-wayland
    polkit-gnome
    zsh
    zsh-completions
    fzf
    pavucontrol
    papirus-icon-theme
    breeze
    flatpak
    swaync
    gvfs
    wlogout
    waypaper
    grimblast
    bibata-cursor-theme
    pacseek
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    nwg-dock-hyprland
    power-profiles-daemon
    python3Packages.pywalfox
    vlc
  ];

  # Enable the Hyprland module
  wayland.windowManager.hyprland.enable = true;

  # Optionally, enable the Zsh program
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # You can also add your Hyprland configuration files here
  # For example, to link a hyprland.conf file from your repository:
  # home.file.".config/hypr/hyprland.conf".source = ./path/to/your/hyprland.conf;
}