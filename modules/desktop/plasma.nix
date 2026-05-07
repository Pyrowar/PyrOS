{
  flake.nixModules.plasma =
    { pkgs, lib, ... }:
    {
      services.displayManager.plasma-login-manager.enable = true; # Only available in NixOS 26.05 or above.
      services.desktopManager.plasma6.enable = true;

      programs.partition-manager.enable = true;
      programs.ssh.startAgent = true;
      programs.kdeconnect.enable = true;
      programs.kde-pim = {
        enable = true;
        merkuro = true;
      };

      environment.systemPackages = with pkgs; [
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

      environment.plasma6.excludePackages = with pkgs; [ kdePackages.discover ];

      # Override cursor so Steam window matches the rest of the desktop.
      # KDE default cursors are at: /run/current-system/sw/share/icons/
      environment.sessionVariables = {
        XCURSOR_THEME = lib.mkDefault "Breeze";
        XCURSOR_SIZE = lib.mkDefault "24";
      };

    };
}
