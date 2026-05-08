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
      # Expose home user files (read-only) to Signal. Hopefully fixes drag-and-drop issues.
      services.flatpak.overrides.settings."org.signal.Signal".Context = "filesystems=home:ro";
    };
}
