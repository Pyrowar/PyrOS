{
  flake.nixosModules.warehouse =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "io.github.flattool.Warehouse";
          origin = "flathub";
        }
      ];

    };
}
