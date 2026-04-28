{ pkgs, ... }:

{
  # ------------------------------------------------------------------ #
  # Display manager + desktop
  # ------------------------------------------------------------------ #
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # ------------------------------------------------------------------ #
  # dconf — GNOME settings database
  # ------------------------------------------------------------------ #
  programs.dconf.enable = true;

  # ---------------------------------------------------------------- #
  # GNOME packages
  # ---------------------------------------------------------------- #
  environment.systemPackages = with pkgs; [ nemo-with-extensions ];
  
  # ------------------------------------------------------------------ #
  # Exclude unwanted packages bundled with the GNOME install
  # ------------------------------------------------------------------ #
  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
}
