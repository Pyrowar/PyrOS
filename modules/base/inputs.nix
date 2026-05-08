{ inputs, lib, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = lib.mkDefault "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
  };

  imports = [
    inputs.flake-file.flakeModules.default
  ];
  flake-file.outputs = "flake-parts";
}
