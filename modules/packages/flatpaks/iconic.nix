{
  flake.nixosModules.iconic =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "nl.emphisia.icon";
          origin = "flathub";
        }
      ];

    };
}
