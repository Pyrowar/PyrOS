# TODO: move to pyro.nix
{ config, ... }:

let
  user = config.system.user;
in

{
  hjem.users.${user} = {
    directory = "/home/${user}";

    # ------------------------------------------------------------------ #
    # XDG user directories
    #
    # The Barracuda directories are bind-mounted into $HOME by storage.nix,
    # so XDG paths point to the home-relative mount points directly.
    # Written to ~/.config/user-dirs.dirs on first install.
    # ------------------------------------------------------------------ #

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

    # ---------------------------------------------------------------- #
    # Autostart
    # ---------------------------------------------------------------- #
    files.".config/autostart/easyeffects.desktop" = {
      clobber = false;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Easy Effects
        Exec=flatpak run com.github.wwmm.easyeffects
        X-KDE-autostart-enabled=true
      '';
    };

    files.".config/autostart/signal.desktop" = {
      clobber = false;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Signal
        Exec=flatpak run org.signal.Signal
        X-KDE-autostart-enabled=true
      '';
    };

  };
}
