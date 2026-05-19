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
      pkgs,
      lib,
      config,
      ...
    }:
    {
      # NixOS options
      system.user = "pyro";
      system.description = "Kajetan Ziółkowski";
      system.maintenance = "manual";
      system.wifi.sops = false; # enable: pulls wifi passwords from sops
      locale.preset = "pl";
      locale.timeZone = "Europe/Warsaw";
      boot.kernelPackages = pkgs.linuxPackages_latest;
      hardware.nvidia.driver = "production";
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

        secrets.wifi_passwords = lib.mkIf config.system.wifi.sops {
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
        mic-filter-chain
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

      # standalone packages
      # you can specify package versions with:
      # pkgs.stable.somePackage
      # pkgs.unstable.somePackage
      # environment.systemPackages = with pkgs; [];

      # ------------------------------------------------------------------ #
      # Services
      # ------------------------------------------------------------------ #

      # Discover devices with either:
      # wpctl status or pw-top
      services.micFilterChain = {
        enable = true;
        devices = [
          "alsa_input.pci-0000_2b_00.4.analog-stereo" # priority 1000
          "alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.mono-fallback" # priority 990
        ];
      };

      # standalone flatpaks
      # files are stored in ~/.var/app
      services.flatpak.packages = [
        # Flatpak management
        "com.github.tchx84.Flatseal"
        "io.github.flattool.Warehouse"
        # Audio
        "org.pipewire.Helvum"
        "io.github.bhack.mini-eq"
        # Core apps
        "ca.desrt.dconf-editor"
        "io.github.diegopvlk.Cine"
        "com.github.PintaProject.Pinta"
        "be.alexandervanhee.gradia"
        "org.gnome.World.Iotas"
        "io.gitlab.news_flash.NewsFlash"
        "de.haeckerfelix.Fragments"
        "com.github.johnfactotum.Foliate"
        # Cool Libadwaita
        "com.github.neithern.g4music" # Gapless
        "org.nickvision.tubeconverter" # Parabolic
        "ca.edestcroix.Recordbox"
        "io.speedofsound.SpeedOfSound"
        "re.sonny.Eloquent"
        "app.drey.Dialect"
        "com.github.finefindus.eyedropper"
        "io.github.ronniedroid.concessio"
        "app.drey.EarTag"
        "info.febvre.Komikku"
        # Games
        "org.gnome.Chess"
        # Others
        "org.upscayl.Upscayl"
        "no.mifi.losslesscut"
        # Theming
        # "io.github.swordpuffin.rewaita"
      ];

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
