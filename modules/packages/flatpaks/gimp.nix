{
  flake.nixosModules.gimp =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.gimp.GIMP";
          origin = "flathub";
        }
      ];
    };

}
