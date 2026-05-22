{
  flake.nixosModules.gnome-chess =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.gnome.Chess";
          origin = "flathub";
        }
      ];

    };
}
