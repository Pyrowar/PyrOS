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
        "Environment" =
          "GSETTINGS_SCHEMA_DIR=/run/current-system/sw/share/gsettings-schemas/glib-2.0/schemas";
      };

    };

}
