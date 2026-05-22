{
  flake.nixosModules.eloquent =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "re.sonny.Eloquent";
          origin = "flathub";
        }
      ];

    };
}
