{
  description = "Oscar Berge NixOS config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/${hostname} ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [ "thinkpad" "zenith" ] mkHost;
    };
}
