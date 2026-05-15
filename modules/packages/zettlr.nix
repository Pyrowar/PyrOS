{
  flake.nixosModules.zettlr =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "com.zettlr.Zettlr";
          origin = "flathub";
        }
      ];
    };

}
