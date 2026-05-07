{ inputs, ... }:
{
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.nixosModules.nix-index-database = inputs.nix-index-database.nixosModules.default;
}
