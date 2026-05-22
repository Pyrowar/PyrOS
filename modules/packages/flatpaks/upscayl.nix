{
  flake.nixosModules.upscayl =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.upscayl.Upscayl";
          origin = "flathub";
        }
      ];

    };
}
