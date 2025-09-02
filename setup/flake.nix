{
  description = "ML4W Dotfiles for Hyprland with NixOS support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Define a common system to avoid repetition
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # This is the main output for Home Manager
      homeConfigurations."your-username" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      # This provides a development shell with all the packages from home.nix
      # This will make the `nix develop` command work as you intended.
      devShells.${system}.default = pkgs.mkShell {
        packages = (import ./home.nix { inherit config pkgs; }).home.packages;
      };
    };
}