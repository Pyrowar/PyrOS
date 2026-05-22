{
  flake.nixosModules.pinta =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "com.github.PintaProject.Pinta";
          origin = "flathub";
        }
      ];

    };
}
