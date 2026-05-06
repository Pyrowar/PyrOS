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
      # Expose home user files (read-only) to Signal. It is required for drag and drop to function.
      services.flatpak.overrides.settings."org.signal.Signal".Context = {
        filesystems = [ "home:ro" ];
      };
    };
}
