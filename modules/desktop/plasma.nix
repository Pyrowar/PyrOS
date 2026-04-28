{ pkgs, lib, ... }:

{
  # ---------------------------------------------------------------- #
  # Display manager + desktop
  #
  # X server is disabled — running pure Wayland via SDDM + Plasma 6.
  # Re-enable if you need X11 fallback.
  # ---------------------------------------------------------------- #
  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  # services.displayManager.plasma-login-manager.enable = true; # future replacement, still unstable

  # Pulls in Dolphin, Ark, Gwenview, Okular, Spectacle, KWrite, Konsole, and the full Plasma shell
  services.desktopManager.plasma6.enable = true;

  # ---------------------------------------------------------------- #
  # KDE packages
  #
  # sddm-kcm is not pulled in automatically with sddm.enable — it adds
  # the SDDM section to System Settings.
  # ---------------------------------------------------------------- #
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;
  programs.kde-pim = {
    enable = true;
    merkuro = true; # calendar app
  };

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm # SDDM settings in System Settings
    kdePackages.ksystemlog # system log viewer
    kdePackages.filelight # disk usage visualiser
    kdePackages.kcharselect # character picker
    kdePackages.kompare # graphical file differences tool
    kdePackages.kcolorchooser # colour picker
    kdePackages.kate # text editor
    kdePackages.akregator # RSS feed reader
    haruna # Qt video player based on mpv
    gnome-calculator # better than kcalc
  ];

  # Override cursor so Steam windows match the rest of the desktop.
  # KDE default cursors are at: /run/current-system/sw/share/icons/
  environment.sessionVariables = {
    XCURSOR_THEME = lib.mkDefault "Breeze";
    XCURSOR_SIZE = lib.mkDefault "24";
  };

  # Exclude unwanted packages bundled with the Plasma install:
  environment.plasma6.excludePackages = with pkgs; [ kdePackages.discover ];

}
