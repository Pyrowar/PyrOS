{ inputs, ... }:
{

  flake-file.inputs.nix-flatpak = {
    url = "github:gmodena/nix-flatpak";
  };

  flake.nixosModules.flatpak =
    { ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      services.flatpak = {
        enable = true;
        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
        ];
      };
    };

}
