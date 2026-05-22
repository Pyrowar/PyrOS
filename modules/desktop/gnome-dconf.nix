# TODO: dconf2nix
{
  # Discover options: dconf watch /
  # After switching from KDE to GNOME: dconf reset -f /
  flake.nixosModules.gnome-dconf =
    { config, lib, ... }:
    {
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              # Dconf locale and xkb follows locale.preset
              "system/locale" = {
                region =
                  if config.locale.preset == "pl" then
                    "pl_PL.UTF-8"
                  else if config.locale.preset == "en" then
                    "en_GB.UTF-8"
                  else
                    throw "Unknown locale.preset: ${config.locale.preset}";
              };
              "org/gnome/desktop/input-sources" = {
                sources =
                  if config.locale.preset == "pl" then
                    "[('xkb', 'pl')]"
                  else if config.locale.preset == "en" then
                    "[('xkb', 'us')]"
                  else
                    throw "Unknown locale.preset: ${config.locale.preset}";
              };
              "org/gnome/mutter" = {
                experimental-features = [ "variable-refresh-rate" ];
              };
              "org/gnome/desktop/interface" = {
                font-name = "Adwaita Sans 11";
                document-font-name = "Adwaita Sans 11";
                monospace-font-name = "Adwaita Mono 11";
                font-antialiasing = "rgba"; # subpixel
                font-hinting = "slight";
                # cursor-theme = "Remus-White";
                # icon-theme = "Adwaita-Yellow";
                color-scheme = "prefer-dark";
                gtk-enable-primary-paste = false;
              };
              "org/gnome/desktop/wm/preferences" = {
                button-layout = "appmenu:minimize,maximize,close";
              };
              "org/gnome/settings-daemon/plugins/color" = {
                night-light-enabled = true;
                night-light-temperature = lib.gvariant.mkUint32 3158;
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
              # Disable beggars
              "org/gnome/settings-daemon/plugins/housekeeping" = {
                donation-reminder-enabled = false;
              };
              "org/gnome/desktop/notifications" = {
                show-in-lock-screen = false;
              };

              # ------------------------------------------------------------------ #
              # Extensions
              # ------------------------------------------------------------------ #

              # Tiling Shell
              "org/gnome/shell/extensions/tilingshell" = {
                # Import layouts
                layouts-json = builtins.readFile ../../assets/dconf/tilingshell/tilingshell-layouts.json;
                # Dconf load options that match .txt located in ../../assets/dconf/tilingshell/tilingshell-settings.txt
                edge-tiling-mode = "default";
                enable-autotiling = true;
                enable-snap-assistant-windows-suggestions = false;
                enable-tiling-system-windows-suggestions = true;
                enable-window-border = true;
                inner-gaps = lib.gvariant.mkUint32 10;
                outer-gaps = lib.gvariant.mkUint32 8;
                selected-layouts = [
                  [
                    "504672"
                    "504672"
                  ]
                  [
                    "504672"
                    "504672"
                  ]
                ];
                show-indicator = false;
                snap-assist-sync-layout = false;
                snap-assistant-threshold = lib.gvariant.mkInt32 25;
                top-edge-maximize = false;
                window-border-color = "rgb(93,119,133)";
                window-border-width = lib.gvariant.mkUint32 3;
                window-use-custom-border-color = false;
              };

            };
          }
        ];
      };

    };

}
