{
  description = "Oscar Berge NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      system = "x86_64-linux";
      nixpkgsConfig = { allowUnfree = true; };
    in
      {
        nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config = nixpkgsConfig;
            };
          };
          modules = [
            ./configuration.nix
            { nixpkgs.config = nixpkgsConfig; }
          ];
        };
      };
}
