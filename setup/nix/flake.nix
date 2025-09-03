{
  description = "The ML4W Dotfiles for Hyprland System-wide Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # This is the key part: A flake-based NixOS configuration
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # This module imports your existing configuration.nix and merges it.
          # You can safely leave this out if your existing configuration.nix is minimal.
          # If you want to use this flake as your primary config, you should define
          # all of your other system settings here.
          /etc/nixos/configuration.nix

          # All your system-wide packages and configurations go here
          {
            # Install all of your user-level programs and packages system-wide
            environment.systemPackages = with pkgs; [
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
              pipx
            python3.13-pygobject

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
              # waypaper
              grimblast
              bibata-cursors
              nwg-dock-hyprland
              power-profiles-daemon
              pywalfox-native
              vlc
              nautilus
            ];

            # This enables fontconfig and installs your fonts system-wide
            fonts = {
              fontconfig.enable = true;
              packages = with pkgs; [
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
          }
        ];
      };
    };
}