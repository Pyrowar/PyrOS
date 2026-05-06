# TODO: merge with pyro.nix
{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.msi-b350-tomahawk
  ];

  # ------------------------------------------------------------------ #
  # User configuration
  # ------------------------------------------------------------------ #

  system.user        = "pyro";
  system.description = "Default User";

  # ------------------------------------------------------------------ #
  # Locale
  # ------------------------------------------------------------------ #

  locale.preset   = "pl";
  locale.timeZone = "Europe/Warsaw";

  # ------------------------------------------------------------------ #
  # Nvidia
  # ------------------------------------------------------------------ #

  hardware.nvidia.driver = "beta";
  hardware.nvidia.cuda   = true;

  # ------------------------------------------------------------------ #
  # Swap
  # ------------------------------------------------------------------ #

  # Set swap method, either:

  # zram without hibernate:
  # system.swap.method = "zram";

  # or zswapfile with optional hibernate:
  # system.swap.method    = "zswapfile";
  # system.swap.hibernate = true;
  # system.swap.size      = 16;
  # system.swap.device    = "laptop";
}