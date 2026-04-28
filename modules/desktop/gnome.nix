{ ... }:

{
  # ------------------------------------------------------------------ #
  # Display manager + desktop
  # ------------------------------------------------------------------ #
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # ------------------------------------------------------------------ #
  # dconf — GNOME settings database
  #
  # Required for declarative GNOME configuration.
  # ------------------------------------------------------------------ #
  programs.dconf.enable = true;

  # ------------------------------------------------------------------ #
  # Excluded GNOME packages
  #
  # Remove unwanted apps bundled with the GNOME install.
  # Full list: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktop-managers/gnome.nix
  # ------------------------------------------------------------------ #
  # environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
}
