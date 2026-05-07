{ inputs, ... }:
{
  flake-file.inputs.hjem = {
    url = "github:feel-co/hjem";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  flake.nixosModules.hjem = inputs.hjem.nixosModules.default;
}
