# DO-NOT-EDIT. 
# Remember to configure your `username.nix` file first, before you proceed!
# This file is just a bootstrap flake to use on a fresh system.
# First, copy it to your flake directory and rename it to `flake.nix`.
# Do `nix run .#write-flake` to generate your actual flake out of it.
# Then `sudo nix flake update --flake /etc/nixos` to pull in changes.
# Only then can you actually start rebuilding your system.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };
}
