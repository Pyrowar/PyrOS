{ inputs, ... }:
{
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.nixosModules.nixtools =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index-database
      ];

      programs.nix-index-database.comma.enable = true;

      environment.systemPackages = with pkgs; [
        nixos-install-tools
        nix-output-monitor
        nvd
      ];
    };
}
