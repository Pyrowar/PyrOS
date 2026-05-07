{
  flake.nixosModules.vivaldi =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ vivaldi ];
    };
}
