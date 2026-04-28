{ pkgs, config, ... }:

let
  user = config.system.user;
in
{
  environment.systemPackages = with pkgs; [ onlyoffice-desktopeditors ];

  hjem.users.${user} = {
    directory = "/home/${user}";
    files.".local/share/fonts/corefonts" = {
      clobber = false;
      source = "${pkgs.corefonts}/share/fonts/truetype";
    };
  };
}
