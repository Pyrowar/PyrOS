{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.nixosModules.sops-nix =
    { pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops-nix ];
      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    };
}
