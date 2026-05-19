{
  flake.nixosModules.vivaldi =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "com.vivaldi.Vivaldi";
          origin = "flathub";
        }
      ];

      services.flatpak.overrides.settings."com.vivaldi.Vivaldi" = {
        "Context" = [
          "filesystems=/etc/nixos/assets/themes/vivaldi:ro" # omit :ro to default to :rw
        ];
        "Environment" = [
          "GSETTINGS_SCHEMA_DIR=/run/current-system/sw/share/gsettings-schemas/glib-2.0/schemas"
        ];

      };

    };

}
