# TODO: move to pyro.nix
{ ... }:

{
  # ---------------------------------------------------------------- #
  # Systemd: XDG Icon Files
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

}
