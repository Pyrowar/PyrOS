{ pkgs, ... }:

{
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
    nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];
  };

  # Screen Sharing under Wayland
  xdg.portal = {
    enable = true;
    # Add the portal for your compositor, e.g.:
    extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr # For Sway/wlroots
      # xdg-desktop-portal-gtk # For GNOME
      kdePackages.xdg-desktop-portal-kde # For KDE
    ];
  };

}
