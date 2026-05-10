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
      pkgs,
      ...
    }:
    {
      # NixOS options
      system.user = "pyro";
      system.description = "Kajetan Ziółkowski";
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
        lact

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
        "io.github.bhack.mini-eq"
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
            file:///home/pyro/Downloads
            file:///home/pyro/Dokumenty
            file:///mnt/Barracuda/pyro/Notatki
            file:///home/pyro/Obrazy
            file:///home/pyro/Wideo
            file:///home/pyro/Muzyka
            file:///home/pyro/Projekty
            file:///etc/nixos NixOS
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
            XDG_PICTURES_DIR="$HOME/Obrazy"
            XDG_VIDEOS_DIR="$HOME/Wideo"
            XDG_MUSIC_DIR="$HOME/Muzyka"
            XDG_PROJECTS_DIR="$HOME/Projekty"
          '';
        };
      };

      # ---------------------------------------------------------------- #
      # Systemd
      # ---------------------------------------------------------------- #

      # Write XDG .directory icon files onto the Barracuda after it mounts.
      # This makes Dolphin and other file managers show correct folder icons
      # for the bind-mounted XDG dirs.
      # For additional Nautilus compatibility also set gio set.
      systemd.services.xdg-dir-icons = {
        description = "Write XDG .directory icon files and set folder icons via gio";
        wantedBy = [ "multi-user.target" ];
        after = [ "mnt-Barracuda.mount" ];
        requires = [ "mnt-Barracuda.mount" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "pyro";
        };
        script = ''
          # Write .directory files for Dolphin/KDE
          printf '[Desktop Entry]\nIcon=folder-documents\n' > /mnt/Barracuda/pyro/Dokumenty/.directory
          printf '[Desktop Entry]\nIcon=folder-music\n'     > /mnt/Barracuda/pyro/Muzyka/.directory
          printf '[Desktop Entry]\nIcon=folder-pictures\n'  > /mnt/Barracuda/pyro/Obrazy/.directory
          printf '[Desktop Entry]\nIcon=folder-videos\n'    > /mnt/Barracuda/pyro/Wideo/.directory
          printf '[Desktop Entry]\nIcon=folder-projects\n'  > /mnt/Barracuda/pyro/Projekty/.directory

          # Set folder icons via gio for GNOME/Nautilus
          ${pkgs.glib}/bin/gio set /etc/nixos                       metadata::custom-icon-name "folder-nix"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro              metadata::custom-icon-name "folder-user-home"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/git               metadata::custom-icon-name "folder-git"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Dokumenty    metadata::custom-icon-name "folder-documents"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Gry          metadata::custom-icon-name "folder-games"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Książki      metadata::custom-icon-name "folder-books"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Muzyka       metadata::custom-icon-name "folder-music"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Notatki      metadata::custom-icon-name "folder-notes"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Obrazy       metadata::custom-icon-name "folder-pictures"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Projekty     metadata::custom-icon-name "folder-projects"
          ${pkgs.glib}/bin/gio set /mnt/Barracuda/pyro/Wideo        metadata::custom-icon-name "folder-videos"
          ${pkgs.glib}/bin/gio set $HOME/Games                      metadata::custom-icon-name "folder-games"
          ${pkgs.glib}/bin/gio set $HOME/Appimages                  metadata::custom-icon-name "folder-appimage"
          ${pkgs.glib}/bin/gio set $HOME/Dokumenty                  metadata::custom-icon-name "folder-documents"
          ${pkgs.glib}/bin/gio set $HOME/Obrazy                     metadata::custom-icon-name "folder-pictures"
          ${pkgs.glib}/bin/gio set $HOME/Wideo                      metadata::custom-icon-name "folder-videos"
          ${pkgs.glib}/bin/gio set $HOME/Muzyka                     metadata::custom-icon-name "folder-music"
          ${pkgs.glib}/bin/gio set $HOME/Projekty                   metadata::custom-icon-name "folder-projects"
        '';
      };
    };

}
