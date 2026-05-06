{ inputs, ... }:
{
  inputs.flake-file.url = "github:vic/flake-file";
  outputs = inputs: inputs.flake-file.lib.mkFlake { inherit inputs; } ./modules;
}
