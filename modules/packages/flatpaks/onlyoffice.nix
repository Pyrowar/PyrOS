{
  flake.nixosModules.onlyoffice =
    { pkgs, config, ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.onlyoffice.desktopeditors";
          origin = "flathub";
        }
      ];

      hjem.users.${config.system.user} = {
        files.".local/share/fonts/corefonts" = {
          clobber = false;
          source = "${pkgs.corefonts}/share/fonts/truetype";
        };
      };
    };
}
