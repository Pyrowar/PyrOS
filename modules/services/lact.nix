{
  flake.nixosModules.lact =
    { config, ... }:
    {
      users.users.${config.system.user}.extraGroups = [
        "video"
        "render"
      ];
      services.lact.enable = true; # Linux GPU Control Application
    };
}
