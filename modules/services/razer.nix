{
  flake.nixosModules.razer =
    { pkgs, config, ... }:
    {
      users.users.${config.system.user}.extraGroups = [ "openrazer" ];
      hardware.openrazer.enable = true;
      environment.systemPackages = with pkgs; [
        openrazer-daemon
        polychromatic
      ];
    };
}
