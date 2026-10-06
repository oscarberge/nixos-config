{ pkgs, ... }:

let
  connect-ntnu-vpn-browser = pkgs.writeShellApplication {
    name = "connect-ntnu-vpn-browser";
    runtimeInputs = with pkgs; [ xdg-utils util-linux coreutils ];
    text = builtins.readFile ./open-url.sh;
  };

  connect-ntnu-vpn = pkgs.writeShellApplication {
    name = "connect-ntnu-vpn";
    runtimeInputs = with pkgs; [ openconnect coreutils ];
    text = ''
      OPEN_URL=${connect-ntnu-vpn-browser}/bin/connect-ntnu-vpn-browser
    '' + builtins.readFile ./connect.sh;
  };
in
{
  environment.systemPackages = [ connect-ntnu-vpn ];
}
