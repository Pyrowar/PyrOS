{
  flake.nixosModules.lact =
    { config, ... }:
    {
      services.lact.enable = true; # Linux GPU Control Application
      config = {
        users.users.${config.system.user}.extraGroups = [
          "video"
          "render"
        ];
      };
    };
}
