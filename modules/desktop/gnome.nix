{
  flake.nixosModules.gnome =
    { lib, pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.games.enable = false;
      # dconf-editor, devhelp, d-spy, gnome-builder, sysprof
      services.gnome.core-developer-tools.enable = false;

      # Discover options: dconf watch /
      # After switching from KDE to GNOME: dconf reset -f /
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                # Czcionki
                font-name = "Adwaita Sans 11";
                document-font-name = "Adwaita Sans 11";
                monospace-font-name = "Adwaita Mono 11";
                font-antialiasing = "rgba"; # subpixel
                font-hinting = "slight";
                # Wygląd
                cursor-theme = "Adwaita";
                color-scheme = "prefer-dark";
                # Wallpaper...
                # Ekrany
                # Mysz i panel dotykowy
                gtk-enable-primary-paste = false;
                # Programy startowe
              };
              "org/gnome/desktop/wm/preferences" = {
                # Okna
                button-layout = "appmenu:minimize,maximize,close";
              };
              "org/gnome/settings-daemon/plugins/color" = {
                # Ekrany
                night-light-enabled = true;
                night-light-temperature = lib.gvariant.mkUint32 3158;
              };
              "org/gnome/desktop/input-sources" = {
                sources = "[('xkb', 'pl')]";
              };

            };
          }
        ];
      };

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      environment.systemPackages = with pkgs; [
        dconf-editor
        gnome-tweaks
        gnome-extension-manager
        resources
      ];

      # Packages to be excluded
      environment.gnome.excludePackages = with pkgs; [
        yelp # GNOME help
        epiphany # GNOME browser
        geary # GNOME email
        showtime # GNOME video player
        gnome-software
        gnome-tour
        gnome-user-docs
        gnome-music
        gnome-console
        gnome-contacts
        gnome-system-monitor
        gnome-connections
        gnome-maps

        # TODO:
        # Reverse gnome core apps declaration: set core.apps.enable to false
        # Apps I like:
        # gnome-font-viewer
        # gnome-characters
        # gnome-clocks
        # gnome-weather
        # gnome-calculator
        # gnome-calendar
        # loupe
        # decibels
        # simple-scan

      ];

    };
}
