{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.desktop.portal = lib.mkOption {
    type = lib.types.enum [
      "kde"
      "gnome"
      "wlr"
    ];
    default = "kde";
    description = "XDG desktop portal to use. Match your DE: kde, gnome, or wlr (wlroots/Sway).";
  };
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
        with pkgs;
        {
          kde = [ kdePackages.xdg-desktop-portal-kde ];
          gnome = [ xdg-desktop-portal-gtk ];
          wlr = [ xdg-desktop-portal-wlr ];
        }
        .${config.desktop.portal};
    };
  };
}
