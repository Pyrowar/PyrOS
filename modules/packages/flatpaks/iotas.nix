{
  flake.nixosModules.iotas =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "org.gnome.World.Iotas";
          origin = "flathub";
        }
      ];
      
    };
}
