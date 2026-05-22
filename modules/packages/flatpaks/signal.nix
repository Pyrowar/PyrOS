{
  flake.nixosModules.signal =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.signal.Signal";
          origin = "flathub";
        }
      ];
      # Hopefully fixes drag-and-drop issues.
      services.flatpak.overrides."org.signal.Signal" = {
        Context = {
          filesystems = [ "home:ro" ];

        };

      };

    };
}
