{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.nixosModules.sops-nix-external = inputs.sops-nix.nixosModules.default;

  flake.nixosModules.sops-nix =
    { self, pkgs, ... }:
    {
      imports = [ self.nixosModules.sops-nix-external ];
      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    };
}
