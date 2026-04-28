{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixos-install-tools
    nix-output-monitor
    nvd
  ];
}
