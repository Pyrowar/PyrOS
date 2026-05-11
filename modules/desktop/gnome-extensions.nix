{
  flake.nixosModules.gnome-extensions =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # From most important to least
        # Core
        gnomeExtensions.caffeine
        gnomeExtensions.appindicator
        valent
        gnomeExtensions.valent
        gnomeExtensions.bluetooth-battery-meter
        # Aesthetic
        rewaita
        gnomeExtensions.blur-my-shell
        gnomeExtensions.user-themes
        gnomeExtensions.open-bar
        gnomeExtensions.top-bar-organizer
        gnomeExtensions.space-bar
        gnomeExtensions.logo-menu
        gnomeExtensions.vitals
        gnomeExtensions.accent-directories
        gnomeExtensions.night-theme-switcher
        gnomeExtensions.dynamic-music-pill
        # QoL
        gnomeExtensions.dash-to-dock
        gnomeExtensions.tiling-shell
        gnomeExtensions.alphabetical-app-grid
      ];
      # Valent KDE Connect
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
