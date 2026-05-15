{ inputs, ... }:
{
  # nix-flatpak only manages the system installations
  # if you used flatpak before nix-flatpak, be sure to remove any leftover user installations
  # flatpak uninstall --user "reverse.notation.appname"
  flake-file.inputs.nix-flatpak = {
    url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  flake.nixosModules.nix-flatpak =
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
