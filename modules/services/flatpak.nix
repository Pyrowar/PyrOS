{ pkgs, config, ... }:

{
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
  };

  xdg.portal.extraPortals =
    if config.services.desktopManager.plasma6.enable then
      [ pkgs.kdePackages.xdg-desktop-portal-kde ]
    else
      [ pkgs.xdg-desktop-portal-gtk ];
  fonts.fontDir.enable = true;

}
