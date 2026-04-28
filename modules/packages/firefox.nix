{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    programs.firefox = {
      enable = true;
      # Use system file picker
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
      # Force ALSA instead of PulseAudio
      package =
        (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped
          { };
      # Install KDE Browser Integration
      nativeMessagingHosts.packages = lib.mkIf (config.desktop.portal == "kde") [
        pkgs.kdePackages.plasma-browser-integration
      ];
    };

    # Screen Sharing under Wayland
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
  };
}
