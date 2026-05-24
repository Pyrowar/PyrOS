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
        # mini-eq-controls is in version 6
        # gnomeExtensions.mini-eq-controls
        # Aesthetic
        gnomeExtensions.user-themes
        gnomeExtensions.blur-my-shell
        gnomeExtensions.logo-menu
        gnomeExtensions.vitals
        # QoL
        gnomeExtensions.tiling-shell
        gnomeExtensions.alphabetical-app-grid
      ];

      # Valent patch for GNOME 50
      nixpkgs.overlays = [
        (final: prev: {
          gnomeExtensions = prev.gnomeExtensions // {
            valent = prev.gnomeExtensions.valent.overrideAttrs (old: {
              postInstall = (old.postInstall or "") + ''
                metadata="$out/share/gnome-shell/extensions/valent@andyholmes.ca/metadata.json"
                tmp=$(mktemp)
                ${final.jq}/bin/jq '."shell-version" += ["50"]' "$metadata" > "$tmp"
                mv "$tmp" "$metadata"
              '';
            });
          };
        })
      ];

      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

}
