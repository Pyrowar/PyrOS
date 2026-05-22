{
  flake.nixosModules.concessio =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "io.github.ronniedroid.concessio";
          origin = "flathub";
        }
      ];

    };
}
