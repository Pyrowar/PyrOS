# TODO: dconf
{
  flake.nixModules.gnome =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      programs.dconf.enable = true;

      environment.systemPackages = with pkgs; [ nemo-with-extensions ];

      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];

    };
}
