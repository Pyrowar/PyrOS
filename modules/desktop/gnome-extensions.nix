{
  flake.nixosModules.gnome-extensions =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # Core
        valent
        gnomeExtensions.valent
        gnomeExtensions.caffeine
        gnomeExtensions.appindicator
        gnomeExtensions.bluetooth-battery-meter
        # Aesthetic
        gnomeExtensions.user-themes
        gnomeExtensions.blur-my-shell
        gnomeExtensions.logo-menu
        gnomeExtensions.vitals
        # QoL
        gnomeExtensions.tiling-shell
        gnomeExtensions.alphabetical-app-grid
        # Windows-like
        # gnomeExtensions.arcmenu
        # gnomeExtensions.dash-to-panel
      ];
      # Valent KDE Connect
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
