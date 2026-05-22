{
  flake.nixosModules.mini-eq =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "io.github.bhack.mini-eq";
          origin = "flathub";
        }
      ];

    };
}
