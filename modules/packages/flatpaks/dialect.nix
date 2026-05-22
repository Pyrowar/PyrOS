{
  flake.nixosModules.dialect =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "app.drey.Dialect";
          origin = "flathub";
        }
      ];
      
    };
}
