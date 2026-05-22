{
  flake.nixosModules.fragments =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "de.haeckerfelix.Fragments";
          origin = "flathub";
        }
      ];

    };
}
