{ config, pkgs, ... }:

{
    # Set a state version to prevent a warning
    home.stateVersion = "24.05"; # Replace with your NixOS version
	
	home.username = "raabe";
	home.homeDirectory = "/home/raabe";

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
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        libnotify
        kitty
        kdePackages.qtwayland
        fastfetch
        eza
        python3
        brightnessctl
        networkmanagerapplet
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
        libsForQt5.qt5ct
        kdePackages.qt6ct
        waybar
        rofi-wayland
        polkit_gnome
        zsh
        zsh-completions
        fzf
        pavucontrol
        papirus-icon-theme
        flatpak
        swaynotificationcenter
        gvfs
        wlogout
        waypaper
        grimblast
        bibata-cursors
        nwg-dock-hyprland
        power-profiles-daemon
        pywalfox-native
        vlc
    ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
    ];

    # Enable the Hyprland module
    # wayland.windowManager.hyprland.enable = true;

    # Optionally, enable the Zsh program
    # programs.zsh = {
    #     enable = true;
    #     enableCompletion = true;
    # };

    # You can also add your Hyprland configuration files here
    # For example, to link a hyprland.conf file from your repository:
    # home.file.".config/hypr/hyprland.conf".source = ./path/to/your/hyprland.conf;
}
