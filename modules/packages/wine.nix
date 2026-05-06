{
  flake.nixosModules.wine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wine-staging
        winetricks
      ];
    };
}
