{ inputs, ... }:
{
  flake-file.inputs.app-manager = {
    url = "github:kem-a/AppManager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.nixosModules.app-manager =
    { ... }:
    {
      environment.systemPackages = [
        inputs.app-manager.packages.x86_64-linux.default
      ];

    };
}
