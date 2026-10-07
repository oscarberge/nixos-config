{
  description = "Oscar Berge NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      nixpkgsConfig = { allowUnfree = true; };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = nixpkgsConfig;
      };

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./hosts/${hostname}
          { nixpkgs.config = nixpkgsConfig; }
        ];
      };
    in
    {
      nixosConfigurations = {
        thinkpad = mkHost "thinkpad";
        zenith = mkHost "zenith";
      };
    };
}
