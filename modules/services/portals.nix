{ config, pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals =
      if config.services.desktopManager.plasma6.enable then
        [ pkgs.kdePackages.xdg-desktop-portal-kde ]
      else if config.services.desktopManager.gnome.enable then
        [ pkgs.xdg-desktop-portal-gtk ]
      else
        [ pkgs.xdg-desktop-portal-wlr ];
  };
}