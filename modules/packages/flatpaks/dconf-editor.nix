{
  flake.nixosModules.dconf-editor =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "ca.desrt.dconf-editor";
          origin = "flathub";
        }
      ];

    };
}
