{
  inputs,
  self,
  lib,
  config,
  ...
}:
{
  options.flake.hosts.snowdrift = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Name of the nixosModule to use for the snowdrift host.";
  };

  # ------------------------------------------------------------------ #
  # NixOS unstable
  # ------------------------------------------------------------------ #
  # To switch to this channel:
  #   sudo nixos-rebuild switch --flake /etc/nixos#snowdrift
  # ------------------------------------------------------------------ #
  flake-file.inputs.nixpkgs-unstable.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-unstable";

  flake.nixosConfigurations = lib.mkIf (config.flake.hosts.snowdrift != null) {
    snowdrift = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ self.nixosModules.${config.flake.hosts.snowdrift} ];
    };
  };
}
