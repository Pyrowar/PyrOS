{
  flake.nixosModules.switcheroo =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "io.gitlab.adhami3310.Converter";
          origin = "flathub";
        }
      ];
      
    };
}
