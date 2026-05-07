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
      
      programs.bash.enable = true;
      programs.bash.interactiveShellInit = ''
        rebuild() {
          local before=$(readlink -f /run/current-system)
          git -C /etc/nixos add -A
          sudo -v
          sudo nixos-rebuild switch --flake /etc/nixos |& nom
          nvd diff $before /run/current-system
        }
        rebuild-boot() {
          local before=$(readlink -f /run/current-system)
          git -C /etc/nixos add -A
          sudo -v
          sudo nixos-rebuild boot --flake /etc/nixos |& nom
          nvd diff $before /run/current-system
        }
      '';
      environment.shellAliases = {
        rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos |& nom";
        rebuild-dry = "sudo nixos-rebuild dry-activate --flake /etc/nixos |& nom";
        flake-update = "sudo nix flake update --flake /etc/nixos";
        write-flake = "nix run path:/etc/nixos#write-flake";
        diff-boot = "nvd diff /run/booted-system /run/current-system";
      };
    };
}
