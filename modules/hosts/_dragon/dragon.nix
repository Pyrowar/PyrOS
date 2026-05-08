{ self, ... }:
{
  flake.nixosConfigurations.snowdrift = self.lib.mkHost {
    module = self.nixosModules.dragon;
    hostname = "snowdrift";
    channel = "unstable";
    extraModules = [ { boot.initrd.kernelModules = [ "ntsync" ]; } ];
  };
  flake.nixosConfigurations.permafrost = self.lib.mkHost {
    module = self.nixosModules.dragon;
    hostname = "permafrost";
    channel = "stable";
  };

  flake.nixosModules.dragon =
    {
      pkgs,
      self,
      config,
      ...
    }:
    {
      # NixOS options
      system.user = "dragon";
      system.description = "Default User";
      system.maintenance = "manual";
      locale.preset = "pl";
      locale.timeZone = "Europe/Warsaw";
      hardware.nvidia.driver = "stable";
      hardware.nvidia.cuda = false;
      system.swap = {
        method = "zram"; # or zswapfile
        # hibernate = true;
        # size = 16;
        # device = "laptop";
      };
      hardware.nvidia.prime = {
        mode = "offload";
        onTheGo = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

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
      # files are stored in ~/.var/app
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
