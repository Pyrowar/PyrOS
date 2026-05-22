{
  flake.nixosModules.icon-library =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.gnome.design.IconLibrary";
          origin = "flathub";
        }
      ];

    };
}
