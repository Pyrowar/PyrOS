{
  inputs,
  self,
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
  flake.nixosConfigurations = {

    snowdrift = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        self.nixosModules.${config.system.user}
        { networking.hostName = "snowdrift"; }
        { boot.initrd.kernelModules = [ "ntsync" ]; }
        {
          nixpkgs.overlays = [
            (final: prev: {
              stable = import inputs.nixpkgs-stable {
                system = final.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              };
            })
          ];
        }
      ];
    };

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
}
