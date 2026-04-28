{ config, ... }:

{
  users.users.${config.system.user}.extraGroups = [ "networkmanager" ];
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
}
