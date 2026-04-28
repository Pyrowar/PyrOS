{ pkgs, lib, ... }:

{
  # ---------------------------------------------------------------- #
  # Display manager + desktop
  # ---------------------------------------------------------------- #
  services.displayManager.sddm.enable = true;
  # services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  # ---------------------------------------------------------------- #
  # KDE packages
  # ---------------------------------------------------------------- #
  programs.partition-manager.enable = true;
  programs.ssh.startAgent = true; # gnome uses different ssh agent
  programs.kdeconnect.enable = true;
  programs.kde-pim = {
    enable = true;
    merkuro = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
    kdePackages.ksystemlog
    kdePackages.filelight
    kdePackages.kcharselect
    kdePackages.kompare
    kdePackages.kcolorchooser
    kdePackages.kate
    kdePackages.akregator
    kdePackages.kalk
    haruna
  ];
  
  # ------------------------------------------------------------------ #
  # Exclude unwanted packages bundled with the Plasma install
  # ------------------------------------------------------------------ #
  environment.plasma6.excludePackages = with pkgs; [ kdePackages.discover ];

  # Override cursor so Steam window matches the rest of the desktop.
  # KDE default cursors are at: /run/current-system/sw/share/icons/
  environment.sessionVariables = {
    XCURSOR_THEME = lib.mkDefault "Breeze";
    XCURSOR_SIZE = lib.mkDefault "24";
  };

}
