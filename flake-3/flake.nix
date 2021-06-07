{
  description = "My NPM Package";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/20.09";
  };
  outputs = { self, nixpkgs, nixpkgs-stable }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit nixpkgs nixpkgs-stable; };
      modules = [
        ({ nixpkgs, nixpkgs-stable, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              gnome = nixpkgs-stable.gnome3;
            })
          ];
        })
      ];
    };
  };
}