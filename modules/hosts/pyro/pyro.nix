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
      lib,
      config,
      ...
    }:
    {
      # NixOS options
      system.user = "pyro";
      system.description = "Kajetan Ziółkowski";
      system.maintenance = "manual";
      system.wifi.enable = false;
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
          pull.rebase = true;
          push.autoSetupRemote = true;
          core.editor = "micro";
        };
      };

      sops = {
        defaultSopsFile = ./secrets.yaml;
        defaultSopsFormat = "yaml";

        age = {
          # Use your existing SSH key to derive the age key automatically
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          # Or point to an explicit age key file:
          # keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };

        secrets.wifi_passwords = lib.mkIf config.system.wifi.enable {
          format = "dotenv";
        };
      };

      imports = with self.nixosModules; [
        # base
        core
        hjem
        sops-nix
        nix-flatpak

        # hardware
        nvidia

        # desktop
        gnome
        gnome-extensions
        dconf

        # services
        audio
        simple-mic-eq
        bluetooth
        networking
        lact
        razer
        portals
        appimage

        # packages - modules
        cli
        devtools
        nixtools
        fonts
        vivaldi
        gimp
        zettlr
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
        "org.pipewire.Helvum"
        # Cool Libadwaita
        "com.github.neithern.g4music" # Gapless
        "org.nickvision.tubeconverter" # Parabolic
        "io.gitlab.news_flash.NewsFlash"
        "com.github.johnfactotum.Foliate"
        "com.github.finefindus.eyedropper"
        "app.drey.EarTag"
        "ca.edestcroix.Recordbox"
        "io.github.ronniedroid.concessio"
        "io.speedofsound.SpeedOfSound"
        # Games
        "org.gnome.Chess"
        # Others
        "io.github.bhack.mini-eq"
        "org.upscayl.Upscayl"
        "no.mifi.losslesscut"
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

        # Set XDG user dirs
        files.".config/user-dirs.dirs" = {
          clobber = false;
          text = ''
            XDG_DESKTOP_DIR="$HOME/Desktop"
            XDG_DOWNLOAD_DIR="$HOME/Downloads"
            XDG_TEMPLATES_DIR="$HOME/Templates"
            XDG_PUBLICSHARE_DIR="$HOME/Public"
            XDG_DOCUMENTS_DIR="$HOME/Dokumenty"
            XDG_PICTURES_DIR="$HOME/Obrazy"
            XDG_VIDEOS_DIR="$HOME/Wideo"
            XDG_MUSIC_DIR="$HOME/Muzyka"
            XDG_PROJECTS_DIR="$HOME/Projekty"
          '';
        };

        # Add Nautilus bookmarks
        files.".config/gtk-3.0/bookmarks" = {
          clobber = false;
          text = ''
            file:///home/pyro/Downloads
            file:///home/pyro/Dokumenty
            file:///home/pyro/Dokumenty/Notatki
            file:///home/pyro/Dokumenty/Książki
            file:///home/pyro/Obrazy
            file:///home/pyro/Wideo
            file:///home/pyro/Muzyka
            file:///home/pyro/Gry
            file:///home/pyro/Projekty
            file:///etc/nixos NixOS
          '';
        };

      };

    };

}
