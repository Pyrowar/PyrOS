# TODO: maybe dconf2nix
# TODO: dconf locale and input sources should follow system locale
# TODO: hjem -> assets/dconf
{
  # Discover options: dconf watch /
  # After switching from KDE to GNOME: dconf reset -f /
  flake.nixosModules.dconf =
    { lib, ... }:
    {
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "system/locale" = {
                region = "pl_PL.UTF-8";
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
              # disable beggars
              "org/gnome/settings-daemon/plugins/housekeeping" = {
                donation-reminder-enabled = false;
              };
              "org/gnome/desktop/notifications" = {
                show-in-lock-screen = false;
              };

            };
          }
        ];
      };

    };

}
