{
  flake.nixosModules.gnome-extensions =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # From most important to least
        # Core
        gnomeExtensions.caffeine
        gnomeExtensions.appindicator
        gnomeExtensions.valent
        valent
        gnomeExtensions.bluetooth-battery-meter
        morewaita-icon-theme
        # Aesthetic
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dynamic-music-pill
        # QoL
        gnomeExtensions.dash-to-dock
        gnomeExtensions.alphabetical-app-grid
      ];
      # Valent KDE Connect
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
