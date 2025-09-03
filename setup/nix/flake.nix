# Execute it with nix profile install /path/to/your/flake/directory
{
    description = "The ML4W Dotfiles for Hyprland Packages";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in 
        {
            packages.${system}.default = pkgs.buildEnv {
            name = "ml4w-dotfiles-environment";
            paths = with pkgs; [

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
                matugen
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
                font-awesome
                fira-sans
                fira-code
                fira-code-symbols

            ];
        };
    };
}