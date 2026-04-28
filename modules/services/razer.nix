{ pkgs, config, ... }:

{
  # ------------------------------------------------------------------ #
  # User groups — handled by list merging
  # ------------------------------------------------------------------ #
  users.users.${config.system.user}.extraGroups = [ "openrazer" ];

  # ------------------------------------------------------------------ #
  # Razer peripherals
  # ------------------------------------------------------------------ #
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [
    openrazer-daemon # daemon that drives the openrazer kernel modules
    polychromatic # GUI front-end for openrazer (lighting, effects)
  ];
}
