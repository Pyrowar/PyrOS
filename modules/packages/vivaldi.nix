{
  flake.nixosModule.vivaldi =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ vivaldi ];
    };
}
