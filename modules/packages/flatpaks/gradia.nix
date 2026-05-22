{
  flake.nixosModules.gradia =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "be.alexandervanhee.gradia";
          origin = "flathub";
        }
      ];

    };
}
