{ ... }:

{
  programs.bash.enable = true;
  # ------------------------------------------------------------------ #
  # NixOS rebuild helpers require nixutils.nix to work
  # ------------------------------------------------------------------ #
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
    diff-boot = "nvd diff /run/booted-system /run/current-system";
  };

}
