{
  flake.nixosModules.gnome =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.games.enable = false;
      # dconf-editor, devhelp, d-spy, gnome-builder, sysprof
      services.gnome.core-developer-tools.enable = false;

      # Discover options: dconf watch /
      # After switching from KDE to GNOME: dconf reset -f /
      # TODO: Maybe dconf.nix?
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
                # cursor-theme = "Adwaita"; # Currently Win11OS
                color-scheme = "prefer-dark";
                # MoreWaita icon theme...
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

              "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                ];
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                name = "Gradia Screenshot";
                command = "flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE";
                binding = "<Ctrl>Print";
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

      ];

      hjem.users.${config.system.user} = {
        # Create file templates with hjem
        files."Templates/Empty Document.txt" = {
          clobber = false;
          text = "";
        };
        files."Templates/Markdown.md" = {
          clobber = false;
          text = "# Title\n";
        };
        files."Templates/Shell Script.sh" = {
          clobber = false;
          text = "#!/usr/bin/env bash\n\nset -eu\n";
        };
        files."Templates/Nix Expression.nix" = {
          clobber = false;
          text = "{ ... }:\n{\n\n}\n";
        };
      };

    };
}
