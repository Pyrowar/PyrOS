{
  flake.nixosModules.gapless =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "com.github.neithern.g4music";
          origin = "flathub";
        }
      ];

    };
}
