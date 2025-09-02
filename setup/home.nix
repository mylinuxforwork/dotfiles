{ config, pkgs, ... }: {
    
    home = {
        stateVersion = "24.05"; # Replace with your NixOS version
        username = "raabe";
        homeDirectory = "/home/raabe";
    };

    # The list of dependencies for Hyprland
    home.packages = (with pkgs; [

        # General
        wget
        curl
        unzip
        gum
        rsync
        git
        figlet
        xdg-utils
        xdg-user-dirs
        libnotify
        vim
        python3
        flatpak
        jq
        xclip
        neovim
        fzf
        pavucontrol

        # Hyprland
        hyprland
        hyprpaper
        hyprlock
        hypridle
        hyprland-qt-support
        hyprpicker
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland

        # Terminal
        kitty

        # Tools
        kdePackages.qtwayland
        fastfetch
        eza
        brightnessctl
        networkmanagerapplet
        imagemagick
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
        python3Packages.screeninfo
        python3Packages.gobject
        pavucontrol
        papirus-icon-theme
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
        nautilus

        # Fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols

    ]);

    # Optionally, enable the Zsh program
    # programs.zsh = {
    #     enable = true;
    #     enableCompletion = true;
    # };
}
