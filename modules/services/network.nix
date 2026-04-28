{ config, ... }:

{
  # ------------------------------------------------------------------ #
  # User groups — handled by list merging
  # ------------------------------------------------------------------ #
  users.users.${config.system.user}.extraGroups = [ "networkmanager" ];

  # ------------------------------------------------------------------ #
  # Network
  # ------------------------------------------------------------------ #
  networking.networkmanager.enable = true;
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.nftables.enable = true;

}
