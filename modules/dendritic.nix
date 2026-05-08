{ inputs, lib, ... }:
{
  systems = [ "x86_64-linux" ];

  imports = [

    inputs.flake-file.flakeModules.default
    # inputs.flake-file.flakeModules.dendritic
    # too opinionated, pulls in:
    # url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz"
  ];

  flake-file.inputs.flake-file = {
    url = lib.mkDefault "github:vic/flake-file";
  };

  flake-file.inputs.flake-parts = {
    url = lib.mkDefault "github:hercules-ci/flake-parts";
    inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  flake-file.inputs.import-tree = {
    url = lib.mkDefault "github:vic/import-tree";
  };

  # flake-file.outputs = "flake-parts";
  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
  '';
}
