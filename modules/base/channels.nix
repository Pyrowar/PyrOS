{
  inputs,
  self,
  lib,
  config,
  ...
}:
# ------------------------------------------------------------------ #
# NixOS Channels
# ------------------------------------------------------------------ #
# The default channel is set implicitly by current hostname entry.
# Permafrost - default channel points to stable
# Snowdrift - default channel points to unstable
# To switch between them use:
#   sudo nixos-rebuild switch --flake .#hostname
# Where hostname is the name of the default channel.
# ------------------------------------------------------------------ #
{

  flake-file.inputs.nixpkgs-unstable.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-unstable";
  flake-file.inputs.nixpkgs-stable.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-25.11";

  flake.nixosConfigurations = {

    snowdrift = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.${config.system.user}
        { networking.hostName = "snowdrift"; }
        { boot.initrd.kernelModules = [ "ntsync" ]; }
        {
          nixpkgs.overlays = [
            (final: prev: {
              stable = import inputs.nixpkgs-stable { inherit (final) config system; };
            })
          ];
        }
      ];
    };

    permafrost = inputs.nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.${config.system.user}
        { networking.hostName = "permafrost"; }
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable { inherit (final) config system; };
            })
          ];
        }
      ];
    };

  };
}
