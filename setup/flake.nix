{
  description = "A basic Hyprland setup with Home Manager";

  inputs = {
    # Nixpkgs provides a vast collection of packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager helps you manage user-level configurations
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # Define the home-manager configuration for your user
    homeConfigurations."your-username" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home.nix
      ];
    };
  };
}