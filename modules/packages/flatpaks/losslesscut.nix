{
  flake.nixosModules.losslesscut =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "no.mifi.losslesscut";
          origin = "flathub";
        }
      ];

    };
}
