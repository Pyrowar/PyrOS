{
  flake.nixosModules.foliate =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "com.github.johnfactotum.Foliate";
          origin = "flathub";
        }
      ];

    };
}
