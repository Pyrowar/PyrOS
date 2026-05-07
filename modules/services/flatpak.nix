{ inputs, ... }:
{

  flake-file.inputs.nix-flatpak = {
    url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  flake.nixosModules.flatpak =
    { ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      services.flatpak = {
        enable = true;
        uninstallUnmanaged = true;
        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
        ];
      };
    };

}
