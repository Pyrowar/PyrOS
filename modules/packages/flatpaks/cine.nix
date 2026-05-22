{
  flake.nixosModules.cine =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "io.github.diegopvlk.Cine";
          origin = "flathub";
        }
      ];

    };
}
