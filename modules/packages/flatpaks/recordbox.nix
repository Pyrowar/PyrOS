{
  flake.nixosModules.recordbox =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "ca.edestcroix.Recordbox";
          origin = "flathub";
        }
      ];

    };
}
