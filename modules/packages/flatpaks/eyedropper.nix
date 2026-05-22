{
  flake.nixosModules.eyedropper =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "com.github.finefindus.eyedropper";
          origin = "flathub";
        }
      ];

    };
}
