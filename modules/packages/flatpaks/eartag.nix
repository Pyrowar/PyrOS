{
  flake.nixosModules.eartag =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "app.drey.EarTag";
          origin = "flathub";
        }
      ];

    };
}
