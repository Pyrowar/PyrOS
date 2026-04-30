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
      nativeMessagingHosts.packages = lib.mkIf config.services.desktopManager.plasma6.enable [
        pkgs.kdePackages.plasma-browser-integration
      ];
    };
  };
}
