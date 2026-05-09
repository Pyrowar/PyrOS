{ self, ... }:
{
  flake.nixosConfigurations.snowdrift = self.lib.mkHost {
    module = self.nixosModules.pyro;
    hostname = "snowdrift";
    channel = "unstable";
    extraModules = [ { boot.initrd.kernelModules = [ "ntsync" ]; } ];
  };
  flake.nixosConfigurations.permafrost = self.lib.mkHost {
    module = self.nixosModules.pyro;
    hostname = "permafrost";
    channel = "stable";
  };

  flake.nixosModules.pyro =
    {
      self,
      config,
      ...
    }:
    {
      # NixOS options
      system.user = "pyro";
      system.description = "Default User";
      system.maintenance = "manual";
      locale.preset = "pl";
      locale.timeZone = "Europe/Warsaw";
      hardware.nvidia.driver = "beta";
      hardware.nvidia.cuda = true;

      programs.git = {
        enable = true;
        config = {
          user.name = "Kajetan Ziółkowski";
          user.email = "kajetan.ziolkowsky@gmail.com";
          init.defaultBranch = "main";
          pull.rebase = false;
          push.autoSetupRemote = true;
          core.editor = "micro";
        };
      };

      imports = with self.nixosModules; [
        # base
        core
        hjem

        # hardware
        nvidia

        # desktop
        gnome
        gnome-extensions
        
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
        gaming
        obs
        onlyoffice
        signal
      ];

      # packages - modules - options
      gaming = {
        steam = true;
        faugus = true;
        recorder = true;
        heroic = true;
        mangohud = true;
        gamescope = false;
        minecraft = false;
        lsfg = false;
      };

      # standalone flatpaks
      # files are stored in ~/.var/app
      services.flatpak.packages = [
        # Flatpak management
        "com.github.tchx84.Flatseal"
        "io.github.flattool.Warehouse"
        # Core apps
        "io.github.diegopvlk.Cine"
        "com.github.PintaProject.Pinta"
        "be.alexandervanhee.gradia"
        "org.gnome.World.Iotas"
        # Cool Libadwaita
        "com.github.neithern.g4music" # Gapless
        "org.nickvision.tubeconverter" # Parabolic
        "io.gitlab.news_flash.NewsFlash"
        "com.github.johnfactotum.Foliate"
        "com.github.finefindus.eyedropper"
        "app.drey.EarTag"
        "ca.edestcroix.Recordbox"
        "org.gnome.Chess"
        # Others
        "com.github.wwmm.easyeffects"
        "org.upscayl.Upscayl"
        "no.mifi.losslesscut"
        "com.zettlr.Zettlr"
      ];

      # standalone packages
      # you can specify package versions with:
      # pkgs.stable.somePackage
      # pkgs.unstable.somePackage
      # environment.systemPackages = with pkgs; [];

      # ------------------------------------------------------------------ #
      # Hjem
      # ------------------------------------------------------------------ #

      hjem.users.${config.system.user} = {
        directory = "/home/${config.system.user}";

        # Add Nautilus bookmarks
        files.".config/gtk-3.0/bookmarks" = {
          clobber = false;
          text = ''
            file:///etc/nixos NixOS
            file:///home/pyro/Downloads
            file:///home/pyro/Dokumenty
            file:///home/pyro/Muzyka
            file:///home/pyro/Obrazy
            file:///home/pyro/Wideo
          '';
        };

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

      # ---------------------------------------------------------------- #
      # Systemd
      # ---------------------------------------------------------------- #

      # Write XDG .directory icon files onto the Barracuda after it mounts.
      # This makes Dolphin and other file managers show correct folder icons
      # for the bind-mounted XDG dirs.
      systemd.services.xdg-dir-icons = {
        description = "Write XDG .directory icon files";
        wantedBy = [ "multi-user.target" ];
        after = [ "mnt-Barracuda.mount" ];
        requires = [ "mnt-Barracuda.mount" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "pyro";
        };
        script = ''
          printf '[Desktop Entry]\nIcon=folder-documents\n' > /mnt/Barracuda/pyro/Dokumenty/.directory
          printf '[Desktop Entry]\nIcon=folder-music\n'     > /mnt/Barracuda/pyro/Muzyka/.directory
          printf '[Desktop Entry]\nIcon=folder-pictures\n'  > /mnt/Barracuda/pyro/Obrazy/.directory
          printf '[Desktop Entry]\nIcon=folder-videos\n'    > /mnt/Barracuda/pyro/Wideo/.directory
        '';
      };
    };

}
