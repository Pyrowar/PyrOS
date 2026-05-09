{
  flake.nixosModules.gnome-extensions =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dynamic-music-pill
        gnomeExtensions.appindicator
        gnomeExtensions.caffeine
        gnomeExtensions.alphabetical-app-grid
        gnomeExtensions.valent
        morewaita-icon-theme
        valent
      ];
      # Valent KDE Connect
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
