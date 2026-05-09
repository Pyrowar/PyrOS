{
  flake.nixosModules.onlyoffice =
    { pkgs, config, ... }:
    {
      environment.systemPackages = with pkgs; [ onlyoffice-desktopeditors ];

      hjem.users.${config.system.user} = {
        files.".local/share/fonts/corefonts" = {
          clobber = false;
          source = "${pkgs.corefonts}/share/fonts/truetype";
        };
      };
    };
}
