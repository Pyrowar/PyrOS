{
  flake.nixosModules.krita =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ krita ];
    };
}
