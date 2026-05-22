{
  flake.nixosModules.parabolic =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.nickvision.tubeconverter";
          origin = "flathub";
        }
      ];

    };
}
