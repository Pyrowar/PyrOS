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
        gnomeExtensions.open-bar
        gnomeExtensions.top-bar-organizer
        gnomeExtensions.space-bar
        gnomeExtensions.logo-menu
        gnomeExtensions.vitals
        # QoL
        gnomeExtensions.tiling-shell
        gnomeExtensions.alphabetical-app-grid
        gnomeExtensions.dash-to-dock
      ];
      # Valent KDE Connect
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
