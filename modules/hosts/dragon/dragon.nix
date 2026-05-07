# TODO: ignore other hosts?
# error: The option `system.user' has conflicting definition values:
# - In `/nix/store/d7sn804w3z0qfcdrmmgyknrp93vschca-source/modules/hosts/pyro/pyro.nix': "pyro"
# - In `/nix/store/d7sn804w3z0qfcdrmmgyknrp93vschca-source/modules/hosts/dragon/dragon.nix': "dragon"
# Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
{ ... }:
{
  # Flake-parts level options
  # system.user = "dragon";

  flake.nixosModules.dragon =
    {
      pkgs,
      self,
      config,
      ...
    }:
    {
      # NixOS level options
      system.user = "dragon";
      system.description = "Default User";
      locale.preset = "pl";
      locale.timeZone = "Europe/Warsaw";
      hardware.nvidia.driver = "stable";
      hardware.nvidia.cuda = false;
      system.swap.method = "zram";

      imports = with self.nixosModules; [
        # base
        core
        hjem

        # hardware
        nvidia
        nvidia-prime

        # desktop
        gnome

        # services
        audio
        bluetooth
        networking
        razer
        portals
        appimage
        flatpak

        # packages - modules
        cli
        devtools
        nixtools
        firefox
        vivaldi
        fonts
        obs
        onlyoffice
        signal
      ];

      # packages - modules - options
      gaming = {
        steam = true;
        faugus = true;
        heroic = true;
        mangohud = true;
        recorder = false;
        gamescope = false;
        minecraft = false;
        lsfg = false;
      };

      # standalone flatpaks
      services.flatpak.packages = [
        "org.nickvision.tubeconverter"
        "com.zettlr.Zettlr"
      ];

      # standalone packages
      # you can specify package versions with:
      # pkgs.stable.somePackage
      # pkgs.unstable.somePackage
      environment.systemPackages = with pkgs; [
        pinta
        foliate
      ];

      # ------------------------------------------------------------------ #
      # Hjem
      # ------------------------------------------------------------------ #

      hjem.users.${config.system.user} = {
        directory = "/home/${config.system.user}";

        files.".config/user-dirs.dirs" = {
          clobber = false;
          text = ''
            XDG_DESKTOP_DIR="$HOME/Desktop"
            XDG_DOWNLOAD_DIR="$HOME/Downloads"
            XDG_TEMPLATES_DIR="$HOME/Templates"
            XDG_PUBLICSHARE_DIR="$HOME/Public"
            XDG_DOCUMENTS_DIR="$HOME/Dokumenty"
            XDG_MUSIC_DIR="$HOME/Muzyka"
            XDG_PICTURES_DIR="$HOME/Obrazy"
            XDG_VIDEOS_DIR="$HOME/Wideo"
          '';
        };
      };

    };

}
