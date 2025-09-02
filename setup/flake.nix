{
    description = "ML4W Dotfiles for Hyprland with NixOS support";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }:

    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        homeConfig = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
        };
    in {
        # This is the main output for Home Manager
        homeConfigurations."raabe" = homeConfig;

        # This provides a development shell with all the packages.
        devShells.${system}.default = pkgs.mkShell {
            # Directly list the packages from your home.nix
            # This avoids trying to evaluate the full config variable.
            packages = (import ./home.nix { inherit pkgs; config = { }; }).home.packages;
        };
    };
}