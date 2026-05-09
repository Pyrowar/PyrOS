# TODO: dconf2nix, maybe new module?
{
  flake.nixosModules.gnome =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # programs.dconf.enable = true;

      # environment.systemPackages = with pkgs; [  ];

      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];

    };
}
