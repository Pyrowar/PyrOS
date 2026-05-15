{
  flake.nixosModules.gnome-extensions =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # From most important to least
        # Core
        valent
        gnomeExtensions.valent
        gnomeExtensions.caffeine
        gnomeExtensions.appindicator
        gnomeExtensions.bluetooth-battery-meter
        # Aesthetic
        rewaita
        gnomeExtensions.user-themes
        gnomeExtensions.blur-my-shell
        gnomeExtensions.top-bar-organizer
        gnomeExtensions.logo-menu
        gnomeExtensions.vitals
        # QoL
        gnomeExtensions.tiling-shell
        gnomeExtensions.alphabetical-app-grid
        # Windows-like
        gnomeExtensions.arcmenu
        gnomeExtensions.dash-to-panel
      ];
      # Valent KDE Connect
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
