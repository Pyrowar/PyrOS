{
  flake.nixosModules.nixtools =
    { self, pkgs, ... }:
    {
      imports = [ self.nixosModules.nix-index-database ];

      programs.nix-index-database.comma.enable = true;
      environment.systemPackages = with pkgs; [
        nixos-install-tools
        nix-output-monitor
        nvd
      ];
      
      programs.nh = {
        enable = true;
        flake = "/etc/nixos";
        clean = {
          enable = true;
          extraArgs = "--keep-since 14d --keep 5";
        };
      };
    };
}
