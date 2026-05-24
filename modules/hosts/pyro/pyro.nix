{ self, ... }:
{
  # ------------------------------------------------------------------ #
  # Channels
  # ------------------------------------------------------------------ #

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
      # ------------------------------------------------------------------ #
      # Options
      # ------------------------------------------------------------------ #

      system.user = "pyro";
      system.description = "Kajetan Ziółkowski";
      system.maintenance = "manual";
      system.wifi.sops = false; # enable: pulls wifi passwords from sops
      locale.preset = "pl";
      locale.timeZone = "Europe/Warsaw";
      boot.kernelPackages = pkgs.linuxPackages_latest;
      hardware.nvidia.driver = "production";
      hardware.nvidia.cuda = true;
      services.ntp.enable = true; # default: systemd-timesyncd

      # ------------------------------------------------------------------ #
      # Git
      # ------------------------------------------------------------------ #

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

      # ------------------------------------------------------------------ #
      # Sops-nix
      # ------------------------------------------------------------------ #

      sops = {
        defaultSopsFile = ./secrets.yaml;
        defaultSopsFormat = "yaml";

        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          generateKey = true;
        };

        secrets.wifi_passwords = lib.mkIf config.system.wifi.sops {
          format = "dotenv";
        };
      };

      # ------------------------------------------------------------------ #
      # Modules
      # ------------------------------------------------------------------ #

      imports = with self.nixosModules; [

        # ------------------------------------------------------------------ #
        # Base
        # ------------------------------------------------------------------ #

        core
        locale

        # ------------------------------------------------------------------ #
        # Flakes
        # ------------------------------------------------------------------ #

        hjem
        sops-nix
        app-manager # manager for appimages
        nix-flatpak
        nix-index-database
        nix-citizen # Star Citizen

        # ------------------------------------------------------------------ #
        # Hardware
        # ------------------------------------------------------------------ #

        nvidia

        # ------------------------------------------------------------------ #
        # Desktop
        # ------------------------------------------------------------------ #

        gnome
        gnome-dconf
        gnome-dotfiles
        gnome-extensions
        gnome-backgrounds

        # ------------------------------------------------------------------ #
        # Services
        # ------------------------------------------------------------------ #

        appimage
        audio
        bluetooth
        lact
        mic-filter-chain
        networking
        portals
        razer

        # ------------------------------------------------------------------ #
        # Nixpkgs
        # ------------------------------------------------------------------ #

        # blender
        cli
        devtools
        # firefox
        fonts
        gaming
        # krita
        nixtools
        obs
        # wine

        # ------------------------------------------------------------------ #
        # Flatpaks
        # ------------------------------------------------------------------ #
        # files are stored in ~/.var/app
        # check permissions with:
        # flatpak info --show-permissions reverse.domain.notation
        # or just the overrides:
        # flatpak override --user --show reverse.domain.notation

        # === system === #
        dconf-editor
        flatseal
        helvum
        mini-eq
        warehouse

        # === themes === #
        iconic
        icon-library

        # === 3rd party === #
        gimp
        losslesscut
        onlyoffice
        signal
        # uno-calc
        upscayl
        vivaldi
        zettlr

        # === gnome circle === #
        cine
        concessio
        dialect
        eartag
        eloquent
        eyedropper
        foliate
        fragments
        gnome-chess
        gradia
        iotas
        komikku
        newsflash
        pinta
        switcheroo

        # === libadwaita === #
        gapless
        parabolic
        recordbox

      ];

      # ------------------------------------------------------------------ #
      # Overrides
      # ------------------------------------------------------------------ #

      # gaming.steam.protontricks = false;
      # gaming.gamescope.enable = true;
      # gaming.gamescope.capSysNice = false;
      # gaming.minecraft.enable = true;
      # gaming.lsfg.enable = true;

      # ------------------------------------------------------------------ #
      # Standalone packages
      # ------------------------------------------------------------------ #
      # you can specify package versions with:
      # pkgs.stable.somePackage
      # pkgs.unstable.somePackage

      # environment.systemPackages = with pkgs; [ lug-helper ];
      # services.flatpak.packages = [ ];

      # ------------------------------------------------------------------ #
      # Mic Filter Chain
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
