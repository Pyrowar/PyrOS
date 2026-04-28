{ config, lib, ... }:

{
  options.system.user = lib.mkOption {
    type = lib.types.str;
    description = "Primary user account name.";
  };

  options.system.description = lib.mkOption {
    type = lib.types.str;
    description = "Description for description :D";
  };
  # ------------------------------------------------------------------ #
  # User account — Don't forget to set a password with 'passwd'.
  # ------------------------------------------------------------------ #
  # Hostname is defined in flake.nix!
  # Do NOT use networking.hostName!
  config.users.users.${config.system.user} = {
    isNormalUser = true;
    description = config.system.description;
    extraGroups = [ "wheel" ];
  };

}
