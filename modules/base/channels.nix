{
  inputs,
  self,
<<<<<<< HEAD
  lib,
=======
  config,
>>>>>>> 55b941f0570e56a403f8d02b4e66ee61d3ea2bad
  ...
}:
# ------------------------------------------------------------------ #
# NixOS Channels
# ------------------------------------------------------------------ #
# The default channel is set implicitly by current hostname entry.
# Snowdrift - default channel points to unstable
# Permafrost - default channel points to stable
# To switch between them use:
#   sudo nixos-rebuild switch --flake .#hostname
# Where hostname is the name of the default channel.
# ------------------------------------------------------------------ #
{
<<<<<<< HEAD
  flake-file.inputs.nixpkgs.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-unstable";
  flake-file.inputs.nixpkgs-stable.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-25.11";

  flake.lib.mkHost =
    {
      module,
      hostname,
      channel ? "unstable",
      extraModules ? [ ],
    }:
    let
      nixpkgs = if channel == "unstable" then inputs.nixpkgs else inputs.nixpkgs-stable;
      overlay =
        if channel == "unstable" then
          (final: prev: {
            stable = import inputs.nixpkgs-stable {
              system = final.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
          })
        else
          (final: prev: {
            unstable = import inputs.nixpkgs {
              system = final.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
          });
    in
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
=======
  flake.nixosConfigurations = {

    snowdrift = inputs.nixpkgs.lib.nixosSystem {
>>>>>>> 55b941f0570e56a403f8d02b4e66ee61d3ea2bad
      specialArgs = { inherit inputs self; };
      modules = [
        module
        { networking.hostName = hostname; }
        { nixpkgs.overlays = [ overlay ]; }
      ]
      ++ extraModules;
    };
<<<<<<< HEAD
=======

    permafrost = inputs.nixpkgs-stable.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        self.nixosModules.${config.system.user}
        { networking.hostName = "permafrost"; }
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import inputs.nixpkgs {
                system = final.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              };
            })
          ];
        }
      ];
    };

  };
>>>>>>> 55b941f0570e56a403f8d02b4e66ee61d3ea2bad
}
