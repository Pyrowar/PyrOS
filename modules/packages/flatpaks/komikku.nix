{
  flake.nixosModules.komikku =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "info.febvre.Komikku";
          origin = "flathub";
        }
      ];

    };
}
