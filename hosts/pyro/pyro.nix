{
  flake.nixosModules.pyro =
    { self, config, ... }:
    {
      imports = with self.nixosModules; [
        hjem
        nixtools

        # hardware
        nvidia

        # desktop
        plasma
        plasma-theme

        # services
        audio
        bluetooth
        networking
        razer
        portals
        appimage
        flatpak

        # packages
        # you can specify package versions with:
        # pkgs.stable.somePackage
        # pkgs.unstable.somePackage
        cli
        gaming
        firefox
        vivaldi
        fonts
        gaming
        obs
        onlyoffice
        signal
      ];

      # flatpaks
      services.flatpak.packages =
        map
          (appId: {
            inherit appId;
            origin = "flathub";
          })
          [
            "com.github.wwmm.easyeffects"
            "org.fooyin.fooyin"
            "org.kde.marknote"
            "info.colobot.Colobot"
            "org.nickvision.tubeconverter"
            "com.github.PintaProject.Pinta"
            "no.mifi.losslesscut"
            "com.zettlr.Zettlr"
            "org.upscayl.Upscayl"
            "net.fasterland.converseen"
            # "org.qbittorrent.qBittorrent"
            # "org.kde.optiimage"
            "com.github.johnfactotum.Foliate"
            "org.audacityteam.Audacity"
            "org.signal.Signal"
          ];

      # ------------------------------------------------------------------------------------------------------------------------------------ #
      #
      # SYSTEM SETTINGS
      #
      # ------------------------------------------------------------------------------------------------------------------------------------ #

      # ------------------------------------------------------------------ #
      # User
      # ------------------------------------------------------------------ #

      system.user = "pyro";
      system.description = "Default User";

      # ------------------------------------------------------------------ #
      # Locale
      # ------------------------------------------------------------------ #

      locale.preset = "pl";
      locale.timeZone = "Europe/Warsaw";

      # ------------------------------------------------------------------ #
      # Hardware
      # ------------------------------------------------------------------ #

      hardware.nvidia.driver = "beta";
      hardware.nvidia.cuda = true;

      # ------------------------------------------------------------------------------------------------------------------------------------ #
      #
      # USER SETTINGS
      #
      # ------------------------------------------------------------------------------------------------------------------------------------ #

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
