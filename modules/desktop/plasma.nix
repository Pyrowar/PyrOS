{
  flake.nixosModules.plasma =
    { pkgs, ... }:
    {
      services.displayManager.plasma-login-manager.enable = true; # Only available in NixOS 26.05 or above.
      services.desktopManager.plasma6.enable = true;

      programs.partition-manager.enable = true;
      programs.ssh.startAgent = true;
      programs.kdeconnect.enable = true;
      programs.kde-pim = {
        enable = true;
        merkuro = true;
      };

      environment.systemPackages = with pkgs; [
        kdePackages.ksystemlog
        kdePackages.filelight
        kdePackages.kcharselect
        kdePackages.kompare
        kdePackages.kcolorchooser
        kdePackages.akregator
        kdePackages.kalk
        haruna
      ];

      environment.plasma6.excludePackages = with pkgs; [ kdePackages.discover ];

    };
}
