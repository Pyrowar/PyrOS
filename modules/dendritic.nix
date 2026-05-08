{ inputs, lib, ... }:
{
  systems = [ "x86_64-linux" ];
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];
  flake-file.inputs.nixpkgs-stable.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-25.11";
}
